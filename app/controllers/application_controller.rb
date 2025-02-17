class ApplicationController < ActionController::Base
  # Permite o acesso apenas a navegadores modernos, que suportam imagens em formato WebP,
  # Web Push, badges, Import Maps, CSS nesting e o seletor CSS :has.
  #
  # Este método é chamado automaticamente e não recebe parâmetros. Ele restringe o acesso
  # para navegadores que não atendem aos requisitos mencionados.
  allow_browser versions: :modern

  # Antes de qualquer ação em um controlador Devise, executa o método configure_permitted_parameters.
  # O método é chamado somente se o controlador atual for um controlador do Devise.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permite parâmetros adicionais durante o processo de cadastro e atualização da conta do usuário.
  #
  # @param [Devise::ParameterSanitizer] devise_parameter_sanitizer
  #   O objeto que permite a sanitização dos parâmetros passados durante o processo de autenticação.
  #   Aqui ele está configurado para permitir os parâmetros :nome e :matricula para sign_up e account_update.
  #
  # @return [void] Não retorna nada. Apenas modifica a lista de parâmetros permitidos pelo Devise.
  def configure_permitted_parameters
    # Permite o campo :nome e :matricula no processo de sign_up (cadastro) e account_update (atualização da conta).
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :matricula])
  end

  private

  # Método para garantir que somente administradores possam acessar certas áreas da aplicação.
  #
  # @param [User] current_user
  #   O usuário atualmente autenticado. A função verifica se o usuário possui permissões de administrador.
  #
  # @return [void] Redireciona o usuário para a página inicial se não for administrador, com um alerta.
  def authorize_admin!
    # Verifica se o usuário atual é um administrador.
    # Caso contrário, redireciona para a raiz da aplicação com uma mensagem de alerta de "Acesso não autorizado!".
    redirect_to root_path, alert: "Acesso não autorizado!" unless current_user.admin?
  end
end
