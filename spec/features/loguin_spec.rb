require "rails_helper"

RSpec.feature "Login e Logout no sistema", type: :feature do
  scenario "Login bem-sucedido e logout com e-mail" do
    user = User.create(nome: "andre", email: "andre1@email.com", matricula: "211020993", password: "senha123", password_confirmation: "senha123", role: "student")

    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: user.email
    fill_in "Senha", with: user.password
    click_button "Entrar"

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_content("Avaliações")

    # Realizando logout
    click_button user.nome[0].upcase # Clique no botão do menu
    click_button "Sair"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Bem-vindo ao CAMAAR")
  end

  scenario "Login bem-sucedido e logout com matrícula" do
    user = User.create(nome: "Andre", email: "user@example.com", matricula: "311020992", password: "senha123", password_confirmation: "senha123", role: "student")

    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: user.matricula
    fill_in "Senha", with: user.password
    click_button "Entrar"

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_content("Avaliações")

    # Realizando logout
    click_button user.nome[0].upcase # Clique no botão do menu
    click_button "Sair"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Bem-vindo ao CAMAAR")
  end

  scenario "Login com credenciais inválidas e tentativa de logout" do
    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: "emailerrado123@email.com"
    fill_in "Senha", with: "senhaerrada"
    click_button "Entrar"

    expect(current_path).to eq(new_user_session_path)

    # Tentativa de logout sem estar logado
    expect(page).to have_no_button("Sair")
  end

  scenario "Professor adm acessa o sistema e realiza logout" do
    user_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")

    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")

    # Realizando logout
    click_button user_adm.nome[0].upcase # Clique no botão do menu
    click_button "Sair"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Bem-vindo ao CAMAAR")
  end

  scenario "Professor não adm acessa o sistema e realiza logout" do
    user_not_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: 0)

    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: user_not_adm.matricula
    fill_in "Senha", with: user_not_adm.password
    click_button "Entrar"

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_no_link("Gerenciamento")

    # Realizando logout
    click_button user_not_adm.nome[0].upcase # Clique no botão do menu
    click_button "Sair"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Bem-vindo ao CAMAAR")
  end
end
