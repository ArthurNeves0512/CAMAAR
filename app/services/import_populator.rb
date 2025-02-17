# services/import_populator.rb
module ImportPopulator
  module_function

  def populate(subjects, overwrite)
    subjects.each { |subject| SubjectProcessor.new(subject, overwrite).process }
  end
end
