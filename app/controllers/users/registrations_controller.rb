# Controller responsável por gerenciar o processo de registro de novos usuários.
# Este controlador substitui alguns métodos padrões do Devise para personalizar o fluxo de registro.
module Users
  class RegistrationsController < Devise::RegistrationsController
    # Ação GET /resource/sign_up
    # Carrega o formulário de registro de um novo usuário.
    # 
    # @return [ActionView::Template] Formulário de registro.
    #
    # def new
    #   super
    # end

    # Ação POST /resource
    # Cria um novo usuário com os parâmetros fornecidos no formulário de registro.
    # 
    # @param [Hash] params Parâmetros enviados para o registro do usuário.
    # @option params [String] :matricula A matrícula do novo usuário.
    # @option params [String] :nome O nome do novo usuário.
    # @option params [String] :email O e-mail do novo usuário.
    # @option params [String] :password A senha escolhida pelo novo usuário.
    # @option params [String] :password_confirmation A confirmação da senha escolhida pelo usuário.
    #
    # @return [Redirect] Redireciona para a página de destino após o registro (veja `after_sign_up_path_for`).
    #
    # def create
    #   super
    # end

    # Ação GET /resource/edit
    # Carrega o formulário de edição dos dados do usuário.
    # 
    # @return [ActionView::Template] Formulário de edição.
    #
    # def edit
    #   super
    # end

    # Ação PUT /resource
    # Atualiza os dados do usuário com os parâmetros fornecidos.
    # 
    # @param [Hash] params Parâmetros enviados para a atualização do usuário.
    # @option params [String] :email O novo e-mail do usuário.
    # @option params [String] :password A nova senha do usuário.
    # @option params [String] :password_confirmation A confirmação da nova senha do usuário.
    #
    # @return [Redirect] Redireciona para a página de destino após a atualização.
    #
    # def update
    #   super
    # end

    # Ação DELETE /resource
    # Exclui o usuário da plataforma.
    # 
    # @return [Redirect] Redireciona para a página de confirmação após exclusão.
    #
    # def destroy
    #   super
    # end

    protected

    # Permite os parâmetros adicionais durante o registro de um usuário.
    # O Devise permite adicionar parâmetros personalizados para os formulários de registro.
    #
    # @param [Devise::ParameterSanitizer] devise_parameter_sanitizer O objeto de sanitização de parâmetros.
    # 
    # @return [Array] Lista de chaves permitidas para o registro do usuário.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [
                                                    :matricula,             # A matrícula do usuário
                                                    :nome,                  # O nome completo do usuário
                                                    :email,                 # O e-mail do usuário
                                                    :password,              # A senha do usuário
                                                    :password_confirmation, # Confirmação da senha
                                                  ])
    end

    # Define o caminho para redirecionar o usuário após um cadastro bem-sucedido.
    #
    # @param [User] resource O usuário que foi registrado.
    #
    # @return [String] O caminho de redirecionamento após o cadastro.
    def after_sign_up_path_for(resource)
      # Exemplo: redireciona para a página inicial do usuário autenticado
      authenticated_root_path
    end
  end
end
