# app/services/import_builders.rb

# Handles construction and modification of import data structures
# for academic records during the import process
module ImportBuilders
  module_function

  # Builds an ImportClass from structured data
  def build_class(data)
    ImportClass.new.tap do |import_class|
      import_class.class_code = dig_value(data, %w[classCode class.classCode])
      import_class.semester = dig_value(data, %w[semester class.semester])
      import_class.time = dig_value(data, %w[time class.time])
    end
  end

  # Creates a teacher representation for import
  def build_teacher(data)
    build_base_user(data).tap do |user|
      user.role = :teacher
      user.department = ImportDepartment.new(data["departamento"])
    end
  end

  # Creates a student representation for import
  def build_student(data)
    build_base_user(data).tap do |user|
      user.active_degree = data["curso"]
    end
  end

  # Updates existing turma or adds new one to subject
  def update_or_add_turma(subject, turma)
    existing_turma = find_existing_turma(subject, turma.class_code)

    if existing_turma
      update_existing_turma(existing_turma, turma)
    else
      subject.add_turma(turma)
    end
  end

  private_class_method

  def dig_value(data, keys)
    keys.each do |key|
      path = key.split(".")
      value = data.dig(*path)
      return value if value.present?
    end
    nil
  end

  def build_base_user(data)
    ImportUser.new.tap do |user|
      user.name = data["nome"]
      user.email = data["email"]
      user.matricula = data["matricula"] || data["usuario"]
      user.highest_degree = data["formacao"]
    end
  end

  def find_existing_turma(subject, class_code)
    subject.turmas.find { |turma| turma.class_code == class_code }
  end

  def update_existing_turma(existing, new_turma)
    docente = new_turma.docente
    alunos = new_turma.alunos

    existing.time = new_turma.time
    existing.docente = docente if docente&.name.present?

    return if alunos.empty?
    existing.alunos = alunos
  end
end
