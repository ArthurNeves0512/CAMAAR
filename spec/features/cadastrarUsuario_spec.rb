require "rails_helper"

RSpec.feature "Cadastro de Usuários", type: :feature do
  let(:valid_attributes) do
    {
      matricula: "21102099",
      nome: "Fulano de Tal",
      email: "fulano@example.com",
      password: "senha123",
      password_confirmation: "senha123",
    }
  end

  before do
    visit new_user_registration_path
  end

  scenario "Cadastro bem-sucedido com dados válidos" do
    fill_in "Matrícula", with: valid_attributes[:matricula]
    fill_in "Nome", with: valid_attributes[:nome]
    fill_in "Email", with: valid_attributes[:email]
    fill_in "Senha", with: valid_attributes[:password]
    fill_in "Confirmação de Senha", with: valid_attributes[:password_confirmation]

    expect {
      click_button "Cadastrar"
    }.to change(User, :count).by(1)

    expect(page).to have_current_path(authenticated_root_path)
    expect(page).to have_content("Avaliações")
    expect(User.last).to have_attributes(
      matricula: valid_attributes[:matricula],
      nome: valid_attributes[:nome],
      email: valid_attributes[:email],
    )
  end

  scenario "Cadastro falha por campos obrigatórios ausentes" do
    click_button "Cadastrar"

    expect(page).to have_content("O cadastro não pôde ser concluído devido a 4 erro(s):")
    expect(page).to have_content("Email não pode ficar em branco")
    expect(page).to have_content("Password não pode ficar em branco")
    expect(page).to have_content("Matricula é obrigatória")
    expect(page).to have_content("Nome é obrigatório")
    #expect(User.count).to eq(0)
  end

  scenario "Cadastro falha por senhas não coincidirem" do
    fill_in "Matrícula", with: valid_attributes[:matricula]
    fill_in "Nome", with: valid_attributes[:nome]
    fill_in "Email", with: valid_attributes[:email]
    fill_in "Senha", with: "senha123"
    fill_in "Confirmação de Senha", with: "senhadiferente"

    click_button "Cadastrar"

    expect(page).to have_content("Password confirmation não é igual a Password")
    #expect(User.count).to eq(0)
  end

  scenario "Cadastro falha por email inválido" do
    fill_in "Email", with: "email-invalido"
    click_button "Cadastrar"

    expect(page).to have_content("Email não é válido")
    #expect(User.count).to eq(0)
  end

  scenario "Verificação dos elementos da página de cadastro" do
    expect(page).to have_content("Cadastrar")
    expect(page).to have_field("Matrícula")
    expect(page).to have_field("Nome")
    expect(page).to have_field("Email")
    expect(page).to have_field("Senha")
    expect(page).to have_field("Confirmação de Senha")
    expect(page).to have_button("Cadastrar")
  end
end
