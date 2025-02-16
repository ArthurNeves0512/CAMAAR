require "rails_helper"

RSpec.feature "Gerar relatório CSV para adm", type: :feature do
  let!(:user_adm) do
    User.create(
      nome: "Janilson",
      email: "adm1@example.com",
      matricula: "2110320991",
      password: "senha123",
      password_confirmation: "senha123",
      role: "admin",
    )
  end

  let!(:template) do
    Template.create(
      name: "Template Teste",
      target_audience: "Ensino Médio",
      semester: "2025/1",
    )
  end

  let!(:questionario) do
    Questionnaire.create(
      name: "Questionário - T1F",
      classroom_info: "1A",
      template_id: template.id,
    )
  end

  let!(:question) do
    Question.create(
      name: "Pergunta 1",
      text: "Qual é a capital do Brasil?",
      question_type: "texto",
      template_id: template.id,
    )
  end

  let!(:question_option) do
    QuestionOption.create(
      name: "Opção A",
      text: "Brasília",
      question_id: question.id,
    )
  end

  let!(:submission) do
    Submission.create(
      user_id: user_adm.id,
      questionnaire_id: questionario.id,
    )
  end

  let!(:answer) do
    Answer.create(
      value: "Brasília",
      question_id: question.id,
      questionnaire_id: questionario.id,
      submission_id: submission.id,
    )
  end

  scenario "Download de resultados de formulário CSV" do
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)

    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"

    expect(current_path).to eq(authenticated_root_path)
    click_link "Gerenciamento"
    expect(current_path).to eq(admin_root_path)
    click_link "Resultados"
    expect(current_path).to eq(admin_results_path)

    expect(page).to have_link("Acessar")
    click_link "Acessar", match: :first
    expect(page).to have_link("Gerar Relatório CSV")

    # Simula o download do arquivo CSV
    download_link = find_link("Gerar Relatório CSV")[:href]
    visit download_link

    # Verifica se o CSV contém a resposta esperada
    expect(page.body).to include("Qual é a capital do Brasil?,Brasília")
  end

  scenario "Questionário sem resultados para exportar" do
    questionario_vazio = Questionnaire.create!(
      name: "Questionário Vazio",
      classroom_info: "2B",
      template_id: template.id,
    )

    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"

    click_link "Gerenciamento"
    click_link "Resultados"
    visit exportar_path(questionario_vazio)

    expect(current_path).to eq(admin_results_path)
    expect(page).to have_content("Este formulário não possui resultados para exportar.")
  end
end
