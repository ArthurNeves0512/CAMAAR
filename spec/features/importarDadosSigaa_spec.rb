require "rails_helper"

RSpec.feature "Importar dados do SIGAA", type: :feature do
  background do
    admin = User.create(nome: "Admin", email: "admin@example.com", password: "senha123", password_confirmation: "senha123", role: 2) # role: 2 é para admin
    login_as(admin, scope: :user)

    visit authenticated_root_path
    click_on "Gerenciamento"
    visit admin_root_path
  end

  scenario "Tentar importar os dados (Caminho Feliz)" do
    expect(page).to eq(admin_root_path)
    expect(Subject.count).to eq(0)

    click_on "Importar Dados"

    #   expect(page).to have_content('Dados importados')

    #   expect(page).to have_current_path(root_path)

    #   expect(Subject.count).to be > 0

  end
end
