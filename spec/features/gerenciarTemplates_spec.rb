require 'rails_helper'

RSpec.feature "Gerenciar templates criados", type: :feature do
  background do
    # Criar um usuário admin
    admin = User.create(nome: 'Admin', email: 'admin@example.com', password: 'senha123', password_confirmation: 'senha123', role: 2) # role: 2 é para admin
    login_as(admin, scope: :user)

    # Criando templates com os atributos corretos
    Template.create(name: 'Template 1', target_audience: 'Alunos de TI', semester: '2025/1')
    Template.create(name: 'Template 2', target_audience: 'Alunos de Engenharia', semester: '2025/2')
  end

  scenario "Visualizar a lista de templates" do
    # Acessar a página inicial do admin (dashboard)
    visit admin_templates_path
    #visit admin_root_path
    
    # Clicar no link 'Editar Templates' que leva para a página de templates
    #click_link 'Editar Templates'

    # Verificar se a página de templates foi carregada corretamente
    expect(current_path).to eq(admin_templates_path)  # Corrigido para o caminho da lista de templates
    
    # Verificar se a lista de templates está visível e contém 2 templates
    expect(page).to have_content('Templates Cadastrados')  # Verifica o título correto da página
    expect(page).to have_selector('tr', count: 3)  # Conta a linha do cabeçalho + duas linhas dos templates
    expect(page).to have_content('Template 1')  # Verifica o nome do template 1
    expect(page).to have_content('Template 2')  # Verifica o nome do template 2
    expect(page).to have_content('Alunos de TI')  # Verifica o público alvo do template 1
    expect(page).to have_content('Alunos de Engenharia')  # Verifica o público alvo do template 2
    expect(page).to have_content('2025/1')  # Verifica o semestre do template 1
    expect(page).to have_content('2025/2')  # Verifica o semestre do template 2

    # Verificar se os ícones de edição e exclusão estão presentes
    expect(page).to have_selector('a', text: 'Editar')  # Link de edição
    expect(page).to have_selector('button', text: 'Excluir')  # Botão de exclusão
  end
end
