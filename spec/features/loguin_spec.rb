require 'rails_helper'

RSpec.feature "Login no sistema", type: :feature do
  scenario "Login bem-sucedido com e-mail" do
    user = User.create(nome:'andre',email: 'aluno1@email.com',matricula:'211020992',password:'senha123',password_confirmation:'senha123')
    
    visit root_path
    expect(page).to have_content('Bem-vindo ao Sistema de Questionários')
    click_link 'Login'
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email ou Matrícula', with: user.email  
    fill_in 'Senha', with: user.password  # Corrigido para 'Senha'
    click_button 'Entrar'
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_content('Lista de Questionários')
  end

  
  scenario "Login bem-sucedido com matricula" do
    user = User.create(nome: 'Andre', email: 'user@example.com', matricula: '311020992', password: 'senha123', password_confirmation: 'senha123')
    
    visit root_path
    expect(page).to have_content('Bem-vindo ao Sistema de Questionários')
    click_link 'Login'
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email ou Matrícula', with: user.matricula  
    fill_in 'Senha', with: user.password  # Corrigido para 'Senha'
    click_button 'Entrar'
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_content('Lista de Questionários')
  end


  scenario "Login com credenciais inválidas" do
    visit root_path
    expect(page).to have_content('Bem-vindo ao Sistema de Questionários')
    click_link 'Login'
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email ou Matrícula', with: 'emailerrado123@email.com'  
    fill_in 'Senha', with: 'senhaerrada'  # Corrigido para 'Senha'
    click_button 'Entrar'
    expect(current_path).to eq(new_user_session_path)
  end
  
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
  end

  scenario "Professor nao adm acessa o sistema" do
    user_not_adm = User.create(nome:'Janilson', email: 'adm1@example.com', matricula: '2110320991', password: 'senha123', password_confirmation: 'senha123', role:1)
    
    visit root_path
    expect(page).to have_content('Bem-vindo ao Sistema de Questionários')
    click_link 'Login'
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email ou Matrícula', with: user_not_adm.matricula
    fill_in 'Senha', with: user_not_adm.password
    click_button 'Entrar'
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_no_link('Gerenciamento')

  end

end
