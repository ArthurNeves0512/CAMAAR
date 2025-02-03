require 'rails_helper'

RSpec.feature "Gerar relatorio csv para adm", type: :feature do
  
  
  scenario "Professor adm acessa o sistema" do
    user_adm = User.create(nome: 'Janilson', email: 'adm1@example.com', matricula: '2110320991', password: 'senha123', password_confirmation: 'senha123', role:2)
    
    visit root_path
    expect(page).to have_content('Bem-vindo ao Sistema de Questionários')
    click_link 'Login'
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email ou Matrícula', with: user_adm.email  
    fill_in 'Senha', with: user_adm.password  # Corrigido para 'Senha'
    click_button 'Entrar'
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link('Gerenciamento')
    click_link 'Gerenciamento'
    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content('Exportar csv')
    click_link 'Exportar csv'
    expect(current_path).to eq(exportar_path)



     end


end
