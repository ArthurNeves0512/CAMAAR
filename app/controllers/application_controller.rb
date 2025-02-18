class ApplicationController < ActionController::Base
  # Permite apenas navegadores modernos que suportam imagens webp, web push, badges, import maps, CSS nesting e o seletor :has.
  #
  # @effect Restringe o acesso ao sistema para navegadores modernos, melhorando a compatibilidade com funcionalidades avançadas.
  allow_browser versions: :modern

  # Garante que os parâmetros permitidos sejam configurados corretamente, caso a ação esteja relacionada ao Devise.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Configura os parâmetros permitidos para os métodos do Devise, como 'sign_up' e 'account_update'.
  #
  # @effect Permite que os parâmetros :nome e :matricula sejam aceitos durante o registro e atualização de contas no Devise.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :matricula])
  end

  private

  # Autoriza o acesso apenas para usuários administradores.
  #
  # @effect Redireciona para a página inicial e exibe uma mensagem de alerta caso o usuário não seja administrador.
  def authorize_admin!
    redirect_to root_path, alert: "Acesso não autorizado!" unless current_user.admin?
  end
end
