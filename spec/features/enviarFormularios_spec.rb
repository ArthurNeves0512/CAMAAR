require "rails_helper"

RSpec.feature "Enviar formulários", type: :feature do
  background do
    # Criar um usuário admin
    user_adm = User.create!(
      nome: "Janilson",
      email: "adm1@example.com",
      matricula: "2110320991",
      password: "senha123",
      password_confirmation: "senha123",
      role: "admin"
    )

    # Criar um departamento para vincular matérias
    department = Department.create!(name: "Departamento de Computação")

    # Criar um professor
    professor = User.create!(
      nome: "Prof. Silva",
      email: "prof@example.com",
      matricula: "2110320992",
      password: "senha123",
      password_confirmation: "senha123",
      role: "teacher",
      department_id: department.id
    )

    # Criar uma disciplina
    subject = Subject.create!(
      name: "Matemática",
      code: "MAT101",
      department_id: department.id
    )

    # Criar templates com atributos obrigatórios
    template1 = Template.create!(name: "Template 1", target_audience: "Alunos", semester: "2025/1")
    template2 = Template.create!(name: "Template 2", target_audience: "Professores", semester: "2025/1")

    # Criar turmas vinculadas a um professor e a uma disciplina
    classroom1 = Classroom.create!(
      code: "A101",
      semester: "2025/1",
      subject_id: subject.id,
      teacher_id: professor.id,
      time: "10:00"
    )

    classroom2 = Classroom.create!(
      code: "B202",
      semester: "2025/1",
      subject_id: subject.id,
      teacher_id: professor.id,
      time: "14:00"
    )

    # Acessar a página inicial e logar
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
    expect(page).to have_button("Enviar Formulários")
    click_button "Enviar Formulários"

    expect(page).to have_selector("#modal", visible: true)

    # Preencher o nome do questionário
    fill_in "Digite o nome do questionário", with: "Questionário de Teste"

    # Selecionar um template
    select "Template 1", from: "template_id"

    # Selecionar todas as turmas disponíveis
    all('input[type="checkbox"]').each(&:click)

    # Verificar se o botão está habilitado
    expect(find_button("Enviar")[:disabled]).to be_nil

    # Enviar o formulário
    click_button "Enviar"
    #expect(page).to have_content("✅ Formulários criados com sucesso!")
  end
end
