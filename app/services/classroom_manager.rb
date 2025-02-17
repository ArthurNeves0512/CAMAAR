# app/services/classroom_manager.rb
class ClassroomManager
  def self.update_or_create(classroom, turma, teacher)
    if classroom.new_record?
      teacher ||= User.where(role: :teacher).order("RANDOM()").first
      classroom.update(
        semester: turma.semester,
        time: turma.time,
        subject: classroom.subject,
        teacher: teacher
      )
    end
    classroom
  end
end
