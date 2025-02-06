module Users
  class RegistrationsController < Devise::RegistrationsController
    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [
                                                    :matricula,
                                                    :nome,
                                                    :email,
                                                    :password,
                                                    :password_confirmation,
                                                  ])
    end

    # Customize o redirecionamento após cadastro
    def after_sign_up_path_for(resource)
      # Exemplo: redirecionar para dashboard
      authenticated_root_path
    end
  end
end
