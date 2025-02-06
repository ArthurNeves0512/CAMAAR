require "rails_helper"

RSpec.feature "Gerar relatorio csv para adm", type: :feature do
  scenario "Download de resultados de formulario CSV" do
    user_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")

    visit root_path
    expect(page).to have_content("Bem-vindo ao Sistema de Questionários")
    click_link "Login"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password  # Corrigido para 'Senha'
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")
    click_link "Gerenciamento"
    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content("Exportar csv")
    click_link "Exportar csv"
    expect(current_path).to eq(admin_questionnaires_path)
    click_link "Exportar dados", match: :first
    expect(page.response_headers["Content-Type"]).to eq("text/csv")
    expect(page.response_headers["Content-Disposition"]).to include("attachment")
    expect(page.response_headers["Content-Disposition"]).to include("relatorio_formulario_")
  end
  scenario "Questionario sem resultados para exportar" do
    questionario_vazio = Questionnaire.create(name: "Questionário - T1F", classroom_info: "Turma T1F", template_id: 2)
    user_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")

    visit root_path
    expect(page).to have_content("Bem-vindo ao Sistema de Questionários")
    click_link "Login"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password  # Corrigido para 'Senha'
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")
    click_link "Gerenciamento"
    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content("Exportar csv")
    click_link "Exportar csv"
    expect(current_path).to eq(admin_questionnaires_path)
    expect(page).to have_link("Exportar dados") #clica no link de um questionario sem respostas
    visit exportar_path(questionario_vazio) #visita a controladora e verifica que ta vazio
    expect(current_path).to eq(admin_questionnaires_path) #redireciona novamente para questionarios de adm com a mensagem de erro
    expect(page).to have_content("Este formulário não possui resultados para exportar.")
  end
end
