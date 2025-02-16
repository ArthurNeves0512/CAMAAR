class Admin::ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  class ImportDepartment
    attr_accessor :name

    def initialize(name: "Não definido")
      @name = name
    end
  end

  class ImportUser
    # based on users from class_members.json
    attr_accessor :name, :email, :password, :role, :matricula, :highest_degree, :active_degree, :department

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
      @classroom = ImportClass
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

    def add_alunos(aluno)
      @alunos << aluno
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

    dataList = []

    if params[:files].blank?
      flash[:alert] = "Nenhum arquivo foi selecionado."
      redirect_to new_admin_import_path
      return
    end

    # Inicializa variáveis para armazenar os conteúdos dos arquivos
    class_members_data = nil
    classes_data = nil

    # Itera sobre os arquivos enviados
    params[:files].each do |file|
      case file.original_filename
      when "class_members.json"
        class_members_data = JSON.parse(file.read)
      when "classes.json"
        classes_data = JSON.parse(file.read)
      else
        flash[:alert] = "❌ Erro de processamento. Arquivo não reconhecido: #{file.original_filename}."
        redirect_to new_admin_import_path
        return
      end
    end

    # Verifica se ambos os arquivos foram enviados
    if class_members_data.nil? || classes_data.nil?
      flash[:alert] = "Ambos os arquivos 'class_members.json' e 'classes.json' devem ser enviados."
      redirect_to new_admin_import_path
      return
    end

    # Processa os dados dos arquivos
    process_class_members(class_members_data, dataList)
    process_classes(classes_data, dataList)

    debugvar = 0

    if debugvar == 1
      puts "==== Imported Data Debug ===="
      debug_console(dataList)
      puts "==== End Imported Data Debug ===="
    end

    # populate DB (if overwrite is on replace any match)
    populate_database(dataList, overwrite)

    # Redirect or render as needed
    redirect_to new_admin_import_path, notice: "✅ Dados importados com sucesso."
  rescue JSON::ParserError => _
    # Handle JSON parsing errors
    redirect_to new_admin_import_path, alert: "❌ Erro de processamento."
  end

  def debug_console(dataList)
    dataList.each do |subject|
      puts "Subject: Code=#{subject.code}, Name=#{subject.name}, Department=(#{subject.department.name})"
      subject.turmas.each do |turma|
        puts "ClassCode=#{turma.classCode}, Semester=#{turma.semester}, Time=#{turma.time}"
        if turma.docente && turma.docente.name.present?
          puts "Teacher: #{turma.docente.name} (Email: #{turma.docente.email}, Matricula: #{turma.docente.matricula})"
        end
        if turma.alunos.any?
          puts "|||||===||||| Enrollments |||||===|||||"
          turma.alunos.each do |enrollment|
            puts "Student: #{enrollment.user.name} (Email: #{enrollment.user.email}, Matricula: #{enrollment.user.matricula})"
          end
        end
      end
    end
  end

  def process_classes(data, dataList = [])
    # Process records from classes.json
    data.each do |record|
      subjectData = ImportSubject.new
      subjectData.code = record.dig("code")
      subjectData.name = record.dig("name")

      classData = ImportClass.new
      classData.classCode = record.dig("class", "classCode")
      classData.semester = record.dig("class", "semester")
      classData.time = record.dig("class", "time")

      # if the subject already exists only add the new classes into it
      existing_subject = dataList.find { |d| d.code == subjectData.code }
      if existing_subject
        # check if it has an turma with the same classCode
        existing_class = existing_subject.turmas.find { |t| t.classCode == classData.classCode }
        if existing_class
          existing_subject.name = subjectData.name
          existing_class.time = classData.time
        else
          existing_subject.add_turma(classData)
        end
      else
        subjectData.add_turma(classData)
        dataList.push(subjectData)
      end
    end
  end

  def process_class_members(data, dataList = [])
    # Process records from 'class_members.json'
    data.each do |record|
      subjectData = ImportSubject.new
      subjectData.code = record.dig("code")

      classData = ImportClass.new
      classData.classCode = record.dig("classCode")
      classData.semester = record.dig("semester")

      record.dig("dicente").each do |dicente|
        userData = ImportUser.new
        userData.name = dicente.dig("nome")
        userData.email = dicente.dig("email")
        userData.matricula = dicente.dig("matricula")
        userData.highest_degree = dicente.dig("formacao")
        userData.active_degree = dicente.dig("curso")

        enrollment = ImportEnrollment.new
        enrollment.user = userData
        enrollment.classroom = classData
        classData.add_alunos(enrollment)
      end

      docente = record.dig("docente")
      departmentData = ImportDepartment.new(name: docente.dig("departamento"))
      subjectData.department = departmentData
      userData = ImportUser.new
      userData.name = docente.dig("nome")
      userData.email = docente.dig("email")
      userData.matricula = docente.dig("usuario")
      userData.highest_degree = docente.dig("formacao")
      userData.role = 1
      userData.department = departmentData
      classData.docente = userData

      # if the subject already exists only add the new classes into it
      existing_subject = dataList.find { |d| d.code == subjectData.code }
      if existing_subject
        # check if it has an turma with the same classCode
        existing_class = existing_subject.turmas.find { |t| t.classCode == classData.classCode }
        if existing_class
          existing_class.alunos = classData.alunos
          existing_class.docente = classData.docente
        else
          existing_subject.add_turma(classData)
        end
      else
        subjectData.add_turma(classData)
        dataList.push(subjectData)
      end
    end
  end
end

def populate_database(dataList, overwrite)
  dataList.each do |subject|
    department = Department.find_or_create_by(name: subject.department.name)

    subject_record = Subject.find_or_initialize_by(code: subject.code)
    if subject_record.new_record?
      subject_record.update(name: subject.name, department: department)
    end

    subject.turmas.each do |turma|
      teacher = User.find_or_initialize_by(matricula: turma.docente.matricula)
      if teacher.new_record?
        teacher.update(nome: turma.docente.name, role: 1, password: turma.docente.password, password_confirmation: turma.docente.password, confirmed_at: Time.now, highest_degree: turma.docente.highest_degree, active_degree: turma.docente.active_degree, email: turma.docente.email)
      end

      classroom = Classroom.find_or_initialize_by(code: turma.classCode, subject: subject_record)
      if classroom.new_record?
        if teacher.present?
          # TODO=options: remove nullable || create a dummy user that represents the abscence of a teacher
          # puts "GENERATED"
          teacher = User.where(role: :teacher).order("RANDOM()").first
        end
        classroom.update(semester: turma.semester, time: turma.time, subject: subject_record, teacher: teacher)
      end

      if overwrite
        classroom.enrollments.destroy_all
      end

      turma.alunos.each do |enrollment|
        student = User.find_or_initialize_by(matricula: enrollment.user.matricula)
        if student.new_record?
          student.update(nome: enrollment.user.name, role: 0, password: enrollment.user.password, password_confirmation: enrollment.user.password, confirmed_at: Time.now, highest_degree: enrollment.user.highest_degree, active_degree: enrollment.user.active_degree, email: enrollment.user.email)
        end

        Enrollment.create(user: student, classroom: classroom)
      end
    end
  end
end
