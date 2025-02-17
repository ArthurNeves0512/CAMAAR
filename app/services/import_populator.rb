# app/services/import_populator.rb

# Handles population of academic data into the database from import structures
module ImportPopulator
  module_function

  def populate(subjects, overwrite)
    subjects.each { |subject| process_subject(subject, overwrite) }
  end

  def process_subject(subject, overwrite)
    department = Department.find_or_create_by(name: subject.department.name)
    subject_record = Subject.find_or_initialize_by(code: subject.code)
    return unless update_subject_record(subject_record, subject.name, department)

    process_subject_turmas(subject, subject_record, overwrite)
  end

  class TurmaProcessor
    def initialize(subject_record, overwrite)
      @subject_record = subject_record
      @overwrite = overwrite
    end

    def process(turma)
      teacher = find_or_create_teacher(turma.docente)
      classroom = find_or_create_classroom(turma, teacher)

      handle_classroom_enrollments(classroom, turma.alunos)
    end

    private

    def find_or_create_teacher(teacher_data)
      UserBuilder.find_or_create(teacher_data, :teacher)
    end

    def find_or_create_classroom(turma, teacher)
      classroom = Classroom.find_or_initialize_by(
        code: turma.class_code,
        subject: @subject_record
      )

      ClassroomManager.update_or_create(classroom, turma, teacher)
      classroom
    end

    def handle_classroom_enrollments(classroom, students)
      classroom.enrollments.destroy_all if @overwrite
      students.each do |enrollment|
        student = UserBuilder.find_or_create(enrollment.user, :student)
        Enrollment.create(user: student, classroom: classroom)
      end
    end
  end

  module UserBuilder
    module_function

    def find_or_create(user_data, role)
      user = User.find_or_initialize_by(matricula: user_data.matricula)
      return user unless user.new_record?

      password = user_data.password
      user.update(
        nome: user_data.name,
        role: role,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.current,
        highest_degree: user_data.highest_degree,
        active_degree: user_data.active_degree,
        email: user_data.email
      )
      user
    end
  end

  private_class_method

  def update_subject_record(record, name, department)
    return true unless record.new_record?

    record.update(name: name, department: department)
  end

  def process_subject_turmas(subject, subject_record, overwrite)
    processor = TurmaProcessor.new(subject_record, overwrite)
    subject.turmas.each { |turma| processor.process(turma) }
  end
end
