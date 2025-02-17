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
    # Abrir o modal e esperar ele carregar
    expect(page).to have_button('Enviar Formulários')
    click_button('Enviar Formulários')
   save_and_open_page
    
    expect(page).to have_selector("#modal", visible: true)
  
    # Preencher o nome do questionário
    fill_in "Digite o nome do questionário", with: "Questionário de Teste"
  
    # Selecionar um template
    select 'Template 1', from: 'template_id', match: :first
  
    # Selecionar as turmas
    within find_all('div.flex.items-center.gap-2', text: 'Estudos Em').first do
      all('input[type="checkbox"]').each(&:click)
    end
  
    # Enviar o formulário
    puts find_button("Enviar")[:disabled] # Se for 'true', significa que está desabilitado

    click_button "Enviar"
   
    # Verificar se o sucesso foi exibido
    #expect(find("#modal")).to have_content("✅ Formulários criados com sucesso!", wait: 30)

  end
  
end
