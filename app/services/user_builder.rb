# Responsável por encontrar ou criar um usuário com base nos dados fornecidos.
module UserBuilder
  module_function

  # Encontra um usuário existente ou cria um novo com base nos dados fornecidos.
  #
  # @param user_data [ImportUser] Dados do usuário a ser criado ou encontrado.
  # @param role [Symbol] O papel do usuário, como :student ou :teacher.
  # @return [User] O usuário encontrado ou criado.
  def find_or_create(user_data, role)
    # Busca ou inicializa o usuário com base na matrícula.
    user = User.find_or_initialize_by(matricula: user_data.matricula)
    
    # Retorna o usuário se ele já existir (não é um novo registro).
    return user unless user.new_record?

    # Caso seja um novo registro, atualiza os atributos do usuário.
    password = user_data.password
    user.update(
      nome: user_data.name,
      role: role,
      password: password,
      password_confirmation: password,
      confirmed_at: Time.current,
      highest_degree: user_data.highest_degree,
      active_degree: user_data.active_degree,
      email: user_data.email
    )
    user
  end
end
