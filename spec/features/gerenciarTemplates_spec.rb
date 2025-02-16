require "rails_helper"

RSpec.feature "Gerenciar templates criados", type: :feature do
  background do
    # Criar um usuário admin
    admin = User.create(nome: "Admin", email: "admin@example.com", matricula: '211309921', password: "senha123", password_confirmation: "senha123", role: 'admin') # role: 2 é para admin
    puts admin.errors.full_messages unless admin.persisted?
    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: admin.email
    fill_in "Senha", with: admin.password  # Corrigido para 'Senha'
    click_button "Entrar"
   
    
    # Criando templates com os atributos corretos
    @template1 = Template.create(name: "Avaliação 1", target_audience: "Alunos de TI", semester: "2025/1")
    @template2 = Template.create(name: "Avaliação 2", target_audience: "Alunos de Engenharia", semester: "2025/2")
    
    
    
  end

  scenario "Visualizar a lista de templates" do
    # Acessar a página inicial do admin (dashboard)
    visit admin_templates_path
    
    

    # Verificar se a página de templates foi carregada corretamente
    expect(current_path).to eq(admin_templates_path)

    # Verificar se a lista de templates está visível e contém 2 templates
    expect(page).to have_content("Gerenciamento - Editar Templates")  # Verifica o título correto da página
    expect(page).to have_content("Avaliação 1")  # Verifica o nome do template 1
    expect(page).to have_content("Avaliação 2")  # Verifica o nome do template 2
    expect(page).to have_content("2025/1")  # Verifica o semestre do template 1
    expect(page).to have_content("2025/2")  # Verifica o semestre do template 2

    # Verificar se os ícones de edição e exclusão estão presentes
    expect(page).to have_css('.text-gray-600.hover\:text-blue-600') # botão de editar
    expect(page).to have_css('.text-gray-600.hover\:text-red-600') # botão excluir
  end

  scenario 'Editar um template' do 
    visit admin_templates_path
    # Acessar a página de templates
    #visit admin_templates_path
    #save_and_open_page
    
    
    expect(current_path).to eq(admin_templates_path)
    expect(page).to have_content("Avaliação 1") 
    
    # Clicar no primeiro ícone de edição (✏️) do template 1
    #puts "URL para editar: /admin/templates/#{@template1.id}/edit"
    find("a[href='/admin/templates/#{@template1.id}/edit']").click
  # save_and_open_page

    expect(page).to have_content('Editar Template')
    expect(page).to have_field('template[name]', with: 'Avaliação 1')

  end
  
  scenario 'Excluir template' do
    visit admin_templates_path
    
    expect(current_path).to eq(admin_templates_path)
    expect(page).to have_content("Avaliação 1") 
    find('div.bg-white', text: 'Avaliação 1').find('button[type="submit"]').click
    expect(page).to have_content('Template excluído com sucesso!')
    #save_and_open_page
  end
  
  scenario 'Falha ao carregar a lista de templates', skip_visit: true do
    allow(Template).to receive(:all).and_raise(StandardError, 'ERROR 747')
    visit admin_templates_path
    
    
  
    # Verifique se a mensagem de erro foi exibida na página
    expect(page).to have_content('Não foi possível carregar os templates no momento. Tente novamente mais tarde:')
  end
  

  scenario 'Erro ao excluir template' do
    visit admin_templates_path
    # Simula um erro na exclusão do template (por exemplo, chave estrangeira ou qualquer outro erro)
    allow_any_instance_of(Template).to receive(:destroy).and_raise(StandardError, "Template não pode ser excluído por motivos de que ta calor hoje...Tente novamente mais tarde")
  
    
  
    # Tenta excluir o template, mas deve ocorrer um erro
    find('div.bg-white', text: 'Avaliação 1').find('button[type="submit"]').click
    #save_and_open_page
  
    # Verifica se a mensagem de erro foi exibida
    expect(page).to have_content('Template não pode ser excluído por motivos de que ta calor hoje...Tente novamente mais tarde')
    expect(page).to have_content("Avaliação 1") # Verifica se o template ainda está presente na lista
  end

  scenario 'Erro ao editar template' do

    allow_any_instance_of(Template).to receive(:update).and_raise(StandardError,'Erro ocorrido por motivos de força maior..')
    visit admin_templates_path
    find("a[href='/admin/templates/#{@template1.id}/edit']").click
    fill_in 'Nome', with: 'Novo Nome do Template' #tentativa de atualizar o nome do template

   
    find('input[name="commit"][value="Salvar"]').click
    

    
    
    expect(page).to have_content("Erro ao atualizar o template: 'Erro ocorrido por motivos de força maior..'")
    

  end

  scenario 'Editar questoes do Template' do
    @questao=Question.create(name: 'pergunta1', text: 'O que achou da disciplina?', question_type: 'Múltipla escolha', template_id: @template1.id)

    visit admin_templates_path
    find("a[href='/admin/templates/#{@template1.id}/edit']").click
    puts @template1.id
    find("a[href='/admin/templates/#{@template1.id}/questions/#{@questao.id}/edit']").click
  
    fill_in 'question_text',with: 'O que achou do professor?'
    click_button 'Atualizar Questão'
    
    expect(page).to have_content('Questão atualizada com sucesso!')
  
  end

  scenario 'Excluir questoes do template' do
    @questao=Question.create(name: 'pergunta1', text: 'O que achou da disciplina?', question_type: 'Múltipla escolha', template_id: @template1.id)
    visit admin_templates_path
    find("a[href='/admin/templates/#{@template1.id}/edit']").click
    find('span', text: 'Excluir').click
    #save_and_open_page


  end
  
  


end
