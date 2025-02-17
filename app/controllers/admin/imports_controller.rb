class Admin::ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  # Data classes used during import
  class ImportDepartment
    attr_accessor :name
    def initialize(name: "Não definido")
      @name = name
    end
  end

  class ImportUser
    attr_accessor :name, :email, :password, :role, :matricula,
                  :highest_degree, :active_degree, :department
    def initialize
      @name = ""
      @email = ""
      @password = "alunopassword"
      @role = 0
      @matricula = ""
      @highest_degree = ""
      @active_degree = ""
      @department = ImportDepartment.new
    end
  end

  class ImportEnrollment
    attr_accessor :user, :classroom
    def initialize
      @user = ImportUser.new
      @classroom = ImportClass.new
    end
  end

  class ImportClass
    attr_accessor :classCode, :semester, :time, :docente, :alunos
    def initialize
      @classCode = ""
      @semester = ""
      @time = ""
      @docente = ImportUser.new
      @alunos = []
    end

    def add_alunos(enrollment)
      @alunos << enrollment
    end
  end

  class ImportSubject
    attr_accessor :name, :code, :department, :turmas
    def initialize
      @name = ""
      @code = ""
      @department = ImportDepartment.new
      @turmas = []
    end

    def add_turma(turma)
      @turmas << turma
    end
  end

  def create
    overwrite = params[:overwrite].present?
    files = params[:files]
    unless files.present?
      flash[:alert] = "Nenhum arquivo foi selecionado."
      redirect_to new_admin_import_path and return
    end

    class_members_data = nil
    classes_data = nil
    files.each do |file|
      case file.original_filename
      when "class_members.json"
        class_members_data = parse_json(file)
      when "classes.json"
        classes_data = parse_json(file)
      else
        flash[:alert] = "❌ Erro de processamento. Arquivo não reconhecido: #{file.original_filename}."
        redirect_to new_admin_import_path and return
      end
    end

    unless class_members_data && classes_data
      flash[:alert] = "Ambos os arquivos 'class_members.json' e 'classes.json' devem ser enviados."
      redirect_to new_admin_import_path and return
    end

    data_list = []
    process_class_members(class_members_data, data_list)
    process_classes(classes_data, data_list)
    populate_database(data_list, overwrite)

    redirect_to new_admin_import_path, notice: "✅ Dados importados com sucesso."
  rescue JSON::ParserError
    redirect_to new_admin_import_path, alert: "❌ Erro de processamento."
  end

  private

  # Parse JSON content from a file
  def parse_json(file)
    JSON.parse(file.read)
  end

  # Process records from classes.json
  def process_classes(data, data_list)
    data.each do |record|
      subject = find_or_initialize_subject(data_list, record["code"], record["name"])
      class_data = build_import_class(record["class"])
      update_or_add_turma(subject, class_data)
    end
  end

  # Process records from class_members.json
  def process_class_members(data, data_list)
    data.each do |record|
      subject = find_or_initialize_subject(data_list, record["code"], nil)
      class_data = build_import_class(record)
      class_data.docente = build_teacher(record["docente"])
      subject.department = ImportDepartment.new(name: record["docente"]["departamento"])

      Array(record["dicente"]).each do |dicente|
        enrollment = ImportEnrollment.new
        enrollment.user = build_student(dicente)
        class_data.add_alunos(enrollment)
      end

      update_or_add_turma(subject, class_data)
    end
  end

  # Finds or creates a subject for the given code and optional name
  def find_or_initialize_subject(data_list, code, name)
    subject = data_list.find { |s| s.code == code }
    if subject
      subject.name = name if name&.present?
    else
      subject = ImportSubject.new.tap do |sub|
        sub.code = code
        sub.name = name if name&.present?
      end
      data_list << subject
    end
    subject
  end

  # Updates an existing turma or adds a new one to the subject
  def update_or_add_turma(subject, turma)
    existing = subject.turmas.find { |t| t.classCode == turma.classCode }
    if existing
      existing.time = turma.time
      existing.docente = turma.docente if turma.docente.name.present?
      existing.alunos = turma.alunos unless turma.alunos.empty?
    else
      subject.add_turma(turma)
    end
  end

  # Builds an ImportClass instance from data
  def build_import_class(data)
    ImportClass.new.tap do |ic|
      ic.classCode = data["classCode"] || data.dig("class", "classCode")
      ic.semester  = data["semester"]  || data.dig("class", "semester")
      ic.time      = data["time"]      || data.dig("class", "time")
    end
  end

  # Builds an ImportUser for a teacher
  def build_teacher(data)
    ImportUser.new.tap do |user|
      user.name = data["nome"]
      user.email = data["email"]
      user.matricula = data["usuario"]
      user.highest_degree = data["formacao"]
      user.role = 1
      user.department = ImportDepartment.new(name: data["departamento"])
    end
  end

  # Builds an ImportUser for a student
  def build_student(data)
    ImportUser.new.tap do |user|
      user.name = data["nome"]
      user.email = data["email"]
      user.matricula = data["matricula"]
      user.highest_degree = data["formacao"]
      user.active_degree = data["curso"]
    end
  end

  # Populate the database with the imported data
  def populate_database(data_list, overwrite)
    data_list.each do |subject|
      department = Department.find_or_create_by(name: subject.department.name)
      subject_record = Subject.find_or_initialize_by(code: subject.code)
      subject_record.update(name: subject.name, department: department) if subject_record.new_record?

      subject.turmas.each do |turma|
        teacher = find_or_update_user(turma.docente, 1)
        classroom = Classroom.find_or_initialize_by(code: turma.classCode, subject: subject_record)
        if classroom.new_record?
          teacher ||= User.where(role: :teacher).order("RANDOM()").first
          classroom.update(
            semester: turma.semester,
            time: turma.time,
            subject: subject_record,
            teacher: teacher
          )
        end
        classroom.enrollments.destroy_all if overwrite
        turma.alunos.each do |enrollment|
          student = find_or_update_user(enrollment.user, 0)
          Enrollment.create(user: student, classroom: classroom)
        end
      end
    end
  end

  # Finds or creates a user record (teacher or student) based on matricula
  def find_or_update_user(user_data, role)
    user = User.find_or_initialize_by(matricula: user_data.matricula)
    user.new_record? && update_user(user, user_data, role)
    user
  end

  # Updates the user record with attributes from the import data
  def update_user(user, user_data, role)
    user.update(
      nome: user_data.name,
      role: role,
      password: user_data.password,
      password_confirmation: user_data.password,
      confirmed_at: Time.now,
      highest_degree: user_data.highest_degree,
      active_degree: user_data.active_degree,
      email: user_data.email
    )
  end
end
