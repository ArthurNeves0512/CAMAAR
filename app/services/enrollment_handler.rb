# services/enrollment_handler.rb
class EnrollmentHandler
  def initialize(classroom, overwrite)
    @classroom = classroom
    @overwrite = overwrite
  end

  def process(students)
    clear_enrollments if @overwrite
    create_enrollments(students)
  end

  private

  def clear_enrollments
    @classroom.enrollments.destroy_all
  end

  def create_enrollments(students)
    students.each do |student_data|
      student = UserBuilder.find_or_create(student_data.user, :student)
      Enrollment.create(user: student, classroom: @classroom)
    end
  end
end
