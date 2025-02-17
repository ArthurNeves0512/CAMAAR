require "rails_helper"

RSpec.feature "Gerenciar templates criados", type: :feature do
  background do
    # Criar um usuário admin
    admin = User.create(nome: "andre", email: "andre@example.com", matricula: '211309921', password: "senha123", password_confirmation: "senha123", role: 'student') # role: 2 é para admin
    puts admin.errors.full_messages unless admin.persisted?
    visit root_path
    click_link "Entrar"
    fill_in "Email ou Matrícula", with: admin.email
    fill_in "Senha", with: admin.password  # Corrigido para 'Senha'
    click_button "Entrar"
  end

  scenario "Visualizar a lista de questionários" do
    # Acessar a página inicial do admin (dashboard)
    visit root_path

    first('a.block.bg-white.shadow-md.rounded-lg.p-6.border.border-gray-300.max-w-xs.w-full').click

    find_all('.mb-6.p-6.bg-gray-100.rounded-lg').each do |div|
      div.find_all('input[type="radio"][id="question_1_0"]').each do |radio_button|
        # Ação com cada radio_button, por exemplo:
        radio_button.choose
      end
    end

    click_button 'Avaliar'
    expect(page).to have_content('Avaliação enviada com sucesso!')
    save_and_open_page
  end
end
