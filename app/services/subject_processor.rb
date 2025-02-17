# services/subject_processor.rb
class SubjectProcessor
  def initialize(subject, overwrite)
    @subject = subject
    @overwrite = overwrite
  end

  def process
    department = Department.find_or_create_by(name: @subject.department.name)
    subject_record = Subject.find_or_initialize_by(code: @subject.code)
    return unless update_subject(subject_record, department)

    TurmaProcessor.new(subject_record, @overwrite).process(@subject.turmas)
  end

  private

  def update_subject(subject_record, department)
    return true unless subject_record.new_record?

    subject_record.update(name: @subject.name, department: department)
  end
end
