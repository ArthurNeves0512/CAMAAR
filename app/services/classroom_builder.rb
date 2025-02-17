# services/classroom_builder.rb
module ClassroomBuilder
  module_function

  def find_or_create(turma, teacher, subject_record)
    classroom = Classroom.find_or_initialize_by(
      code: turma.class_code,
      subject: subject_record
    )
    ClassroomManager.update_or_create(classroom, turma, teacher)
    classroom
  end
end
