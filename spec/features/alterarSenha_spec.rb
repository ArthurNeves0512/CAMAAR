require "rails_helper"

RSpec.feature "Redefinir senha do usuario", type: :feature do
  before do
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_link("Esqueceu a senha?")
    click_link "Esqueceu a senha?"
    expect(current_path).to eq(new_user_password_path)
  end

  scenario "insiro um email válido e clico em confirmar email para receber um email para troca de senha" do
    user = User.create(nome: "andre", email: "andre1@email.com", matricula: "211020993", password: "senha123", password_confirmation: "senha123", role: "student")

    fill_in "user_email", with: user.email
    click_button "Recuperar"
    expect(ActionMailer::Base.deliveries.count).to eq(1) #verifica se o actionmailer possui algum deliveri apos enviar o email para o metodo create, fazendo a contagem de emails

    # Pegue o e-mail gerado
    email = ActionMailer::Base.deliveries.last #verifica o ultimo email enviado

    # Verifique os detalhes do e-mail
    expect(email.to).to include(user.email) #verifica pra quem foi enviado
    expect(email.subject).to eq("Reset password instructions") #o assunto
    expect(email.body.to_s).to include("Someone has requested a link to change your password. You can do this through the link below.") #mensagem
  end

  scenario "Clico no link de redefinição de senha e insiro uma nova senha" do
    # Acesse o link de redefinição de senha
    user = User.create(nome: "andre", email: "andre1@email.com", matricula: "211020993", password: "senha123", password_confirmation: "senha123", role: "student")

    fill_in "user_email", with: user.email
    click_button "Recuperar"
    expect(ActionMailer::Base.deliveries.count).to eq(1)

    # Pegue o e-mail gerado
    email = ActionMailer::Base.deliveries.last

    # Verifique os detalhes do e-mail
    reset_password_link = email.body.to_s.match(/href="([^"]+)"/)[1] #regex para pegar o link que aparece no terminal href="http://localhost:3000/users/password/edit?reset_password_token=v8gRQEJsFjzbhoSN2sFo"
    token = reset_password_link.match(/reset_password_token=([^&]+)/)[1] #regex para pegar o token reset_password_token=v8gRQEJsFjzbhoSN2sFo o numero indica o grupo de captura ()
    #[]significa que eu quero que capture caracteres especificos ou nao, no ^indica que eu nao quero que & apareca na captura como " tambem o caracteres + indica que pode capturar qualquer caracter antes desses caracteres excluidos

    visit reset_password_link #visitando o link
    expect(current_url).to include("reset_password_token=#{token}") #verificando se a uurl tem o token esperado http://localhost:3000/users/password/edit?reset_password_token=v8gRQEJsFjzbhoSN2sFo
    expect(page).to have_content("Definir Nova Senha")

    fill_in "user_password", with: "novasenha123"
    fill_in "user_password_confirmation", with: "novasenha123"
    click_button "Alterar Senha"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Senha alterada com sucesso! Você está logado.")
  end
  scenario "Inserindo email invalido" do
    fill_in "user_email", with: "emailNadaAver@aluno.com"
    click_button "Recuperar"
    expect(page).to have_content("Usuário não encontrado. Verifique o e-mail informado.")
  end
end
