require "rails_helper"

RSpec.feature "Importar dados do SIGAA", type: :feature do
  background do
    user_adm = User.create(nome: "Janilson", email: "adm1@example.com", matricula: "2110320991", password: "senha123", password_confirmation: "senha123", role: "admin")

    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: user_adm.email
    fill_in "Senha", with: user_adm.password  # Corrigido para 'Senha'
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")
    click_link "Gerenciamento"
  end

  scenario "Tentar importar os dados válidos" do
    click_link "Importar Dados"

    expect(page).to have_content('Importar Dados')
    expect(page).to have_content('Sobrescrever dados existentes?')
    expect(page).to have_button('Enviar')

    # Testa se o campo de upload está visível
    expect(page).to have_css('input[type="file"]')

    # Simula upload de arquivo JSON válido
    #trocar o caminho do arquivo, para rodar o teste
    attach_file("files[]", "/home/caualp/rails/CAMAAR-2/classes.json", make_visible: true)

    
    # Marca a opção de sobrescrever (opcional)
    check("Sobrescrever dados existentes?")

    # Clica no botão de enviar
    click_button "Enviar"

    # Valida que a importação foi concluída com sucesso
    expect(page).to have_content("Dados importados com sucesso")
    
    # Verifica se os dados foram adicionados ao banco de dados
    expect(Subject.count).to eq(3)  # Espera que 3 registros tenham sido adicionados

  # Verifica os dados do primeiro registro (BANCOS DE DADOS)
    subject1 = Subject.find_by(code: "CIC0097")
    expect(subject1).not_to be_nil
    expect(subject1.name).to eq("BANCOS DE DADOS")
    expect(subject1.code).to eq("CIC0097")
    expect(subject1.department_id).not_to be_nil  # Verifica se o department_id foi atribuído corretamente

    # Verifica os dados do segundo registro (ENGENHARIA DE SOFTWARE)
    subject2 = Subject.find_by(code: "CIC0105")
    expect(subject2).not_to be_nil
    expect(subject2.name).to eq("ENGENHARIA DE SOFTWARE")
    expect(subject2.code).to eq("CIC0105")
    expect(subject2.department_id).not_to be_nil

    # Verifica os dados do terceiro registro (PROGRAMAÇÃO CONCORRENTE)
    subject3 = Subject.find_by(code: "CIC0202")
    expect(subject3).not_to be_nil
    expect(subject3.name).to eq("PROGRAMAÇÃO CONCORRENTE")
    expect(subject3.code).to eq("CIC0202")
    expect(subject3.department_id).not_to be_nil

  end

  scenario "Tentar importar um arquivo inválido" do
    click_link "Importar Dados"

    expect(page).to have_content('Importar Dados')
    expect(page).to have_content('Sobrescrever dados existentes?')
    expect(page).to have_button('Enviar')

    # Simula upload de arquivo inválido (.txt em vez de .json)
    attach_file("files[]", "/home/caualp/rails/CAMAAR-2/README.md", make_visible: true)

    # Clica no botão de enviar
    click_button "Enviar"

    # Valida que uma mensagem de erro foi exibida
    expect(page).to have_content("❌ Erro de processamento.")

    # Verifica que nenhum dado foi adicionado ao banco
    expect(Subject.count).to eq(0)
  end

end
