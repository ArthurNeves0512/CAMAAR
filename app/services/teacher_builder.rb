# services/teacher_builder.rb
module TeacherBuilder
  module_function

  def find_or_create(teacher_data)
    UserBuilder.find_or_create(teacher_data, :teacher)
  end
end
