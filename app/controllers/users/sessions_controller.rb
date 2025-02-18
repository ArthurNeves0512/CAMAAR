module Users
  class SessionsController < Devise::SessionsController
    protected

    # Personaliza o redirecionamento após o login.
    #
    # @param [Object] resource O recurso que está sendo autenticado (normalmente o usuário).
    # @return [String] Caminho para o qual o usuário será redirecionado após o login.
    #
    # Exemplo:
    #   after_sign_in_path_for(resource) # Retorna o caminho de redirecionamento após o login.
    def after_sign_in_path_for(resource)
      # Exemplo: redireciona para a página inicial autenticada.
      authenticated_root_path
    end
  end
end
