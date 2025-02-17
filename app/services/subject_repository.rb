require_relative "import_data_classes"

class SubjectRepository
  def initialize
    @subjects = []
  end

  def find_or_initialize(code, name = nil)
    existing = @subjects.find { |s| s.code == code }
    existing ? update_existing(existing, name) : create_new(code, name)
  end

  def all = @subjects

  private

  def update_existing(subject, new_name)
    subject.name = new_name if valid_name_update?(new_name)
    subject
  end

  def create_new(code, name)
    ImportSubject.new.tap do |s|
      s.code = code
      s.name = name.presence || ""
      @subjects << s
    end
  end

  def valid_name_update?(name) = name.present? && !name.empty?
end
