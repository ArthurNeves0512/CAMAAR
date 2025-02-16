require "rails_helper"

RSpec.feature "Responder questionário", type: :feature do
  background do
    # Criar um usuário administrador
    

    # Criar um template, pois o questionário precisa de um template
    template = Template.create!(name: "Template de Avaliação", target_audience: "Estudantes", semester: "2025.1")

    # Criar um questionário associado ao template
    questionnaire = Questionnaire.create!(name: "Questionário de Avaliação", template: template)

    # Criar as perguntas associadas ao template
    question1 = Question.create!(text: "Como você avalia o curso?", question_type: "Múltipla escolha", template: template)
    question2 = Question.create!(text: "Comentários adicionais", question_type: "Dissertativa", template: template)
    visit root_path
    
  end

  scenario "Acessar e responder um questionário como admin" do
    user_adm = User.create!(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    # Garantir que um questionário válido existe no banco
    questionnaire = Questionnaire.first

    # Visitar a página do questionário
    visit questionnaire_path(questionnaire)

    # Verificar se o título correto do questionário aparece
    expect(page).to have_content("Avaliação - #{questionnaire.name} - #{questionnaire.template.semester}")

    # Verificar se as perguntas estão sendo exibidas
    expect(page).to have_content("Como você avalia o curso?")
    expect(page).to have_content("Comentários adicionais")

    # Verificar se as opções de resposta estão presentes para a primeira pergunta (Múltipla escolha)
    expect(page).to have_selector("input[type=radio][name='submission[answers][#{questionnaire.questions.first.id}]']")

    # Verificar se o campo de resposta dissertativa está presente
    expect(page).to have_selector("input[type=text][name='submission[answers][#{questionnaire.questions.second.id}]']")

    # Agora você pode interagir com o questionário, se desejar, ou simplesmente confirmar o acesso correto
    # Responder a primeira pergunta (Múltipla escolha)
    first("input[type=radio][name='submission[answers][#{questionnaire.questions.first.id}]'][value='Muito bom']").choose

  # Selecionando a primeira opção ("Muito bom")

    # Responder a segunda pergunta (Dissertativa)
    fill_in "submission[answers][#{questionnaire.questions.second.id}]", with: "Muito bom, gostei muito da abordagem prática."

    # Enviar as respostas
    click_button "Avaliar"
    # Verificar se a submissão foi bem-sucedida
    expect(page).to have_content("Avaliação enviada com sucesso", wait: 15)
    expect(current_path).to eq(authenticated_root_path)
  end


  scenario "Acessar e responder um questionário como estudante" do
    user_adm = User.create!(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "student")
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    # Garantir que um questionário válido existe no banco
    questionnaire = Questionnaire.first

    # Visitar a página do questionário
    visit questionnaire_path(questionnaire)

    # Verificar se o título correto do questionário aparece
    expect(page).to have_content("Avaliação - #{questionnaire.name} - #{questionnaire.template.semester}")

    # Verificar se as perguntas estão sendo exibidas
    expect(page).to have_content("Como você avalia o curso?")
    expect(page).to have_content("Comentários adicionais")

    # Verificar se as opções de resposta estão presentes para a primeira pergunta (Múltipla escolha)
    expect(page).to have_selector("input[type=radio][name='submission[answers][#{questionnaire.questions.first.id}]']")

    # Verificar se o campo de resposta dissertativa está presente
    expect(page).to have_selector("input[type=text][name='submission[answers][#{questionnaire.questions.second.id}]']")

    # Agora você pode interagir com o questionário, se desejar, ou simplesmente confirmar o acesso correto
    # Responder a primeira pergunta (Múltipla escolha)
    first("input[type=radio][name='submission[answers][#{questionnaire.questions.first.id}]'][value='Muito bom']").choose

  # Selecionando a primeira opção ("Muito bom")

    # Responder a segunda pergunta (Dissertativa)
    fill_in "submission[answers][#{questionnaire.questions.second.id}]", with: "Muito ruim, não gostei da abordagem prática."

    # Enviar as respostas
    click_button "Avaliar"
    # Verificar se a submissão foi bem-sucedida
    expect(page).to have_content("Avaliação enviada com sucesso", wait: 15)
    expect(current_path).to eq(authenticated_root_path)
  end

end
