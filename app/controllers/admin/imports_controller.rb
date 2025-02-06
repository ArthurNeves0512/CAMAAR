class Admin::ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  class ImportClasses
    attr_accessor :classCode, :semester, :dptoName

    def initialize
      @classCode = ""
      @semester = 0
      @dptoName = ""
    end
  end

  class ImportSubjects
    attr_accessor :code, :name, :turmas

    def initialize
      @code = ""
      @name = ""
      @turmas = []
    end

    def add_turmas(turma)
      @turmas << turma
    end
  end

  def create
    # Check if the overwrite checkbox is checked
    overwrite = params[:overwrite].present?

    dataList = []

    # Process the uploaded files
    params[:files].each do |file|
      # Parse the JSON file
      data = JSON.parse(file.read)

      if data.any? { |record| record.key?("docente") }

        # Process records that contain a "docente" key !
        data.each do |record|
          code = record.dig("code")
          # Assuming you meant to create a new ImportClasses instance:
          classData = ImportClasses.new
          classData.dptoName = record.dig("docente", "departamento")
          classData.classCode = record.dig("classCode")
          classData.semester = record.dig("semester")
          # Find existing subject or create a new one
          subject = dataList.find { |d| d.code == code }
          if subject
            # If the subject already exists, check in that subject turmas (list) for a classCode that matches and set its dptoName
            existing_turma = subject.turmas.find { |t| t.classCode == classData.classCode }
            if existing_turma
              existing_turma.dptoName = classData.dptoName
              existing_turma.semester = classData.semester
            end
          else
            # Create a new subject record
            subjectData = ImportSubjects.new
            subjectData.code = code
            subjectData.add_turmas(classData)
            dataList.push(subjectData)
          end
        end
      else
        # Process records without "docente"
        data.each do |record|
          subjectData = ImportSubjects.new
          subjectData.code = record.dig("code")
          subjectData.name = record.dig("name")

          classData = ImportClasses.new
          classData.classCode = record.dig("class", "classCode")
          classData.semester = record.dig("class", "semester")

          subjectData.add_turmas(classData)

          existing_subject = dataList.find { |d| d.code == subjectData.code }
          if existing_subject
            # If the subject already exists, check if name is not blank
            if existing_subject.name.blank?
              existing_subject.name = subjectData.name
            end
            # check if an turma with the same classCode already exists
            existing_turma = existing_subject.turmas.find { |t| t.classCode == classData.classCode }
            if !(existing_turma)
              existing_subject.add_turmas(classData)
            end
          else
            dataList.push(subjectData)
          end
        end
      end
    end

    # Debug output to the console showing the full final state of dataList
    puts "Final state of dataList:"
    dataList.each do |subject|
      puts "Subject Code: #{subject.code} - Name: #{subject.name}"
      subject.turmas.each do |turma|
        puts "  Class Code: #{turma.classCode}, Semester: #{turma.semester}, Department Name: #{turma.dptoName}"
      end
    end

    # use dataList to populate the database from Departaments > Subjects > Classrooms
    dataList.each do |subject|
      # Find or create the Department
      if subject.turmas.empty?
        next
      end
      department = Department.find_or_create_by(name: subject.turmas.first.dptoName)
      # Find or create Subjects with the created Deparment
      subject_record = Subject.find_or_create_by(code: subject.code, name: subject.name, department_id: department.id)
      # Find or create the Classroom's from subject
      subject.turmas.each do |turma|
        Classroom.find_or_create_by(subject_id: subject_record.id, semester: turma.semester, code: turma.classCode)
      end
    end

    # Redirect or render as needed
    redirect_to new_admin_import_path, notice: "✅ Dados importados com sucesso."
  rescue JSON::ParserError => _
    # Handle JSON parsing errors
    redirect_to new_admin_import_path, alert: "❌ Erro ao processar o arquivo JSON."
  end
end
