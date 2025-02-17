# services/turma_processor.rb
class TurmaProcessor
  def initialize(subject_record, overwrite)
    @subject_record = subject_record
    @overwrite = overwrite
  end

  def process(turmas)
    turmas.each { |turma| process_turma(turma) }
  end

  private

  def process_turma(turma)
    teacher = TeacherBuilder.find_or_create(turma.docente)
    classroom = ClassroomBuilder.find_or_create(turma, teacher, @subject_record)
    EnrollmentHandler.new(classroom, @overwrite).process(turma.alunos)
  end
end
