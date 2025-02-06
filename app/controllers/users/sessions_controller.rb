module Users
  class SessionsController < Devise::SessionsController
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    #def destroy
    #  super # Chama o comportamento padrão do Devise para o logout
    #end

    protected

    # Customize o redirecionamento após login
    def after_sign_in_path_for(resource)
      # Exemplo: redirecionar para dashboard
      authenticated_root_path
    end
  end
end
