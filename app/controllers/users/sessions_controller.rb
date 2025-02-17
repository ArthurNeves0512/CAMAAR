# Controller responsável por gerenciar o processo de autenticação e sessão do usuário.
# Este controlador substitui alguns métodos padrões do Devise para personalizar o fluxo de login.
module Users
  class SessionsController < Devise::SessionsController
    # Ação GET /resource/sign_in
    # Carrega o formulário de login para o usuário.
    # 
    # @return [ActionView::Template] Formulário de login.
    #
    # def new
    #   super
    # end

    # Ação POST /resource/sign_in
    # Processa o login do usuário, validando suas credenciais.
    # 
    # @param [Hash] params Parâmetros enviados para o login do usuário.
    # @option params [String] :email O e-mail do usuário.
    # @option params [String] :password A senha do usuário.
    # 
    # @return [Redirect] Redireciona para a página de destino após o login bem-sucedido.
    #
    # def create
    #   super
    # end

    # Ação DELETE /resource/sign_out
    # Processa o logout do usuário.
    # 
    # @return [Redirect] Redireciona para a página de logout após a saída.
    #
    # def destroy
    #   super # Chama o comportamento padrão do Devise para o logout
    # end

    protected

    # Define o caminho de redirecionamento após o login bem-sucedido.
    #
    # @param [User] resource O usuário autenticado.
    #
    # @return [String] O caminho de redirecionamento após o login.
    def after_sign_in_path_for(resource)
      # Exemplo: redireciona para a página inicial do usuário autenticado (dashboard)
      authenticated_root_path
    end
  end
end
