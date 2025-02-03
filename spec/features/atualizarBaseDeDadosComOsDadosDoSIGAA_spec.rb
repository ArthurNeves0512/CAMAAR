require 'rails_helper'

RSpec.feature "Importar dados do SIGAA", type: :feature do
    background do
      admin = User.create(nome: 'Admin', email: 'admin@example.com', password: 'senha123', password_confirmation: 'senha123', role: 2) # role: 2 = admin
      login_as(admin, scope: :user)
      