# == ClassroomManager
#
# O serviço `ClassroomManager` é responsável por gerenciar a criação e atualização de objetos do modelo `Classroom`.
# Ele garante que, ao criar uma nova turma (`classroom`), um professor (`teacher`) seja atribuído, caso não tenha sido informado.
#
# == Métodos de Classe
#
# === `update_or_create(classroom, turma, teacher)`
#
# Atualiza ou cria uma turma (`classroom`) com base nos dados fornecidos.
# Se a turma for nova (`new_record?`), os atributos são preenchidos e um professor aleatório pode ser atribuído, caso nenhum tenha sido fornecido.
#
# @param [Classroom] classroom A instância da turma a ser atualizada ou criada.
# @param [Object] turma Um objeto contendo os dados da turma, incluindo `semester` e `time`.
# @param [User, nil] teacher O professor responsável pela turma. Se for `nil`, um professor aleatório será selecionado.
# @return [Classroom] Retorna a instância da turma atualizada ou criada.
#
class ClassroomManager
  # Atualiza ou cria uma turma, atribuindo um professor caso necessário.
  def self.update_or_create(classroom, turma, teacher)
    if classroom.new_record?
      # Se nenhum professor foi informado, seleciona um aleatório com o papel de 'teacher'
      teacher ||= User.where(role: :teacher).order("RANDOM()").first
      
      # Atualiza os atributos da turma
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
