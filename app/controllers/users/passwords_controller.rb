class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :require_no_authentication, only: [:create, :update]
  before_action :validate_session, only: [:edit]

  # Sobrescreve o método create para verificar apenas o email
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
  def edit
    @user = User.with_reset_password_token(params[:reset_password_token])

    unless @user
      redirect_to new_user_password_path, alert: "Token inválido ou expirado. Tente novamente."
    end
  end

  # Atualiza a senha do usuário
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

  def validate_session
    unless params[:reset_password_token].present?
      redirect_to new_user_password_path, alert: "Token inválido ou expirado. Solicite a recuperação de senha novamente."
    end
  end

  def password_params
    params.fetch(:user, {}).permit(:password, :password_confirmation, :reset_password_token)
  end
end
