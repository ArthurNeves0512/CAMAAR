require "rails_helper"

RSpec.feature "Importar dados do SIGAA", type: :feature do
  background do
    # Criar um usuário admin
    user_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")
    
    # Criar templates e turmas fictícias
    template1 = Template.create(name: "Template 1")
    template2 = Template.create(name: "Template 2")
    
    classroom1 = Classroom.create(code: "A101", semester: "2021/2")
    classroom2 = Classroom.create(code: "B202", semester: "2021/2")
    
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")
    click_link "Gerenciamento"
  end

  scenario "Enviar formulário de questionário com template e turmas selecionadas" do
    # Abrir o modal
    click_button "Enviar Formulários"

    # Esperar até que o modal esteja visível
    expect(page).to have_selector("#modal", visible: true)

    # Preencher o nome do questionário
    fill_in "Digite o nome do questionário", with: "Questionário de Teste"

    # Selecionar um template
    select "Template 1", from: "template_id"
    

    # Selecionar as turmas
    check("Estudos Em ")

    # Enviar o formulário
    #click_button "Enviar"

    # Verificar se o sucesso foi exibido ou se a página foi redirecionada
    #expect(page).to have_content("Questionário enviado com sucesso") # Ajuste conforme o texto de sucesso
  end
end
