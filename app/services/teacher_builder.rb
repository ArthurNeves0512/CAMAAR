# Responsável por gerenciar a criação e busca de usuários do tipo "professor".
module TeacherBuilder
  module_function

  # Busca ou cria um usuário do tipo "professor" com os dados fornecidos.
  #
  # @param teacher_data [Hash] Dados do professor a serem usados para a criação ou busca.
  # @return [ImportUser] O usuário do tipo professor encontrado ou criado.
  def find_or_create(teacher_data)
    UserBuilder.find_or_create(teacher_data, :teacher)
  end
end
