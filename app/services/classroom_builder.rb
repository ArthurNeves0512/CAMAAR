# Service object responsável por gerenciar a criação ou busca de uma sala de aula.
module ClassroomBuilder
  module_function

  # Encontra ou cria uma nova sala de aula associada a um código de turma e um registro de assunto.
  #
  # @param turma [Turma] A turma que contém o código da sala de aula e o assunto.
  # @param teacher [Professor] O professor que será associado à sala de aula.
  # @param subject_record [Subject] O registro do assunto que será associado à sala de aula.
  # @return [Classroom] A sala de aula encontrada ou criada.
  # @effect Busca ou cria uma nova sala de aula associada ao código da turma e ao assunto fornecido.
  #         Se a sala de aula já existir, a função atualiza suas informações.
  def find_or_create(turma, teacher, subject_record)
    classroom = Classroom.find_or_initialize_by(
      code: turma.class_code,
      subject: subject_record
    )
    ClassroomManager.update_or_create(classroom, turma, teacher)
    classroom
  end
end
