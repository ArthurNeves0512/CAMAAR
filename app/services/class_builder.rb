require_relative "import_builders"
require_relative "import_data_classes"

class ClassBuilder
  def self.build_from_record(record)
    ImportBuilders.build_class(record)
  end

  def self.build_with_staff(record)
    new_class = build_from_record(record)
    new_class.docente = ImportBuilders.build_teacher(record["docente"])
    new_class
  end

  def self.add_students(class_obj, students_data)
    Array(students_data).each do |student|
      enrollment = ImportEnrollment.new
      enrollment.user = ImportBuilders.build_student(student)
      class_obj.add_alunos(enrollment)
    end
    class_obj
  end
end
