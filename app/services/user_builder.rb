# services/user_builder.rb
module UserBuilder
  module_function

  def find_or_create(user_data, role)
    user = User.find_or_initialize_by(matricula: user_data.matricula)
    return user unless user.new_record?

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
