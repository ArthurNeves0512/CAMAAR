require_relative "import_parser"
require_relative "import_populator"
require_relative "subject_repository"
require_relative "class_builder"

class ImportService
  def initialize(files, overwrite)
    @files = files
    @overwrite = overwrite.present?
    @subject_repo = SubjectRepository.new
  end

  def process
    class_members_data, classes_data = ImportParser.parse_files(@files)
    return false unless valid_data?(class_members_data, classes_data)

    process_records(class_members_data, classes_data)
    ImportPopulator.populate(@subject_repo.all, @overwrite)
    true
  rescue JSON::ParserError
    false
  end

  private

  def valid_data?(*data_sets) = data_sets.none?(&:nil?)

  def process_records(class_members, classes)
    class_members.each { |r| process_member_record(r) }
    classes.each { |r| process_class_record(r) }
  end

  def process_class_record(record)
    subject = @subject_repo.find_or_initialize(record["code"], record["name"])
    class_obj = ClassBuilder.build_from_record(record["class"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end

  def process_member_record(record)
    subject = @subject_repo.find_or_initialize(record["code"])
    class_obj = ClassBuilder.build_with_staff(record)
    ClassBuilder.add_students(class_obj, record["dicente"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end
end
