# Controller responsável por gerenciar a recuperação e redefinição de senha dos usuários.
# Este controlador substitui alguns métodos padrões do Devise para personalizar o fluxo de recuperação de senha.
class Users::PasswordsController < Devise::PasswordsController
  # Impede a autenticação para as ações de criação e atualização de senha
  skip_before_action :require_no_authentication, only: [:create, :update]
  
  # Valida a sessão antes de permitir o acesso à tela de edição da senha
  before_action :validate_session, only: [:edit]

  # Sobrescreve o método create para verificar apenas o email
  #
  # @param [Hash] params Parâmetros enviados pelo formulário de recuperação de senha.
  # @option params [String] :user[:email] O endereço de e-mail do usuário que deseja redefinir a senha.
  #   O e-mail será utilizado para localizar o usuário e iniciar o processo de redefinição de senha.
  #
  # @return [Redirect] Redireciona para a página de redefinição de senha ou apresenta um alerta de erro.
  def create
    email = params.dig(:user, :email)

    if email.blank?
      redirect_to new_user_password_path, alert: "O campo de e-mail não pode estar vazio."
      return
    end

    user = User.find_by(email: email)

    if user
      # Gera um token de redefinição de senha
      token = user.send_reset_password_instructions

      if successfully_sent?(user)
        redirect_to edit_user_password_path(reset_password_token: token), notice: "Usuário encontrado! Agora defina sua nova senha."
      else
        Rails.logger.error "Erro ao gerar o link de redefinição de senha para #{email}."
        redirect_to new_user_password_path, alert: "Erro ao gerar o link de redefinição de senha."
      end
    else
      Rails.logger.info "Usuário não encontrado: #{email}."
      redirect_to new_user_password_path, alert: "Usuário não encontrado. Verifique o e-mail informado."
    end
  end

  # Renderiza a tela de edição da senha
  #
  # @param [Hash] params Parâmetros enviados com o token de redefinição.
  # @option params [String] :reset_password_token Token gerado para redefinir a senha do usuário.
  #
  # @return [Redirect] Redireciona para a página de redefinição de senha se o token for válido.
  def edit
    @user = User.with_reset_password_token(params[:reset_password_token])

    unless @user
      redirect_to new_user_password_path, alert: "Token inválido ou expirado. Tente novamente."
    end
  end

  # Atualiza a senha do usuário
  #
  # @param [Hash] params Parâmetros enviados com a nova senha.
  # @option params [String] :user[:password] A nova senha definida pelo usuário.
  # @option params [String] :user[:password_confirmation] Confirmação da nova senha fornecida pelo usuário.
  # @option params [String] :user[:reset_password_token] Token de redefinição de senha.
  #
  # @return [Redirect] Redireciona para a página inicial com uma mensagem de sucesso ou erro.
  def update
    @user = User.reset_password_by_token(password_params)

    if @user.errors.empty?
      sign_in(@user) # Faz login automaticamente após a alteração da senha
      redirect_to root_path, notice: "Senha alterada com sucesso! Você está logado."
    else
      redirect_to edit_user_password_path(reset_password_token: params[:user][:reset_password_token]), alert: "Erro ao atualizar a senha. Verifique os dados e tente novamente."
    end
  end

  private

  # Valida a presença do token de redefinição de senha antes de permitir o acesso à página de edição.
  #
  # @return [Redirect] Redireciona para a página de nova senha se o token estiver ausente ou inválido.
  def validate_session
    unless params[:reset_password_token].present?
      redirect_to new_user_password_path, alert: "Token inválido ou expirado. Solicite a recuperação de senha novamente."
    end
  end

  # Define os parâmetros permitidos para atualizar a senha.
  #
  # @return [Hash] Parâmetros permitidos para a atualização de senha.
  def password_params
    params.fetch(:user, {}).permit(:password, :password_confirmation, :reset_password_token)
  end
end
