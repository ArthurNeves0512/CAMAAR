# Service object responsável por gerenciar a criação ou atualização de salas de aula.
class ClassroomManager
  # Atualiza ou cria uma sala de aula associando informações de turma e professor.
  #
  # @param classroom [Classroom] A sala de aula a ser criada ou atualizada.
  # @param turma [Turma] A turma com informações como semestre e horário.
  # @param teacher [Professor, nil] O professor que será associado à sala de aula. Caso não seja fornecido, um professor aleatório será atribuído.
  # @return [Classroom] A sala de aula atualizada ou criada.
  # @effect Se a sala de aula for nova, ela será criada com as informações de turma e professor.
  #         Caso a sala de aula já exista, ela será atualizada com os dados fornecidos.
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
