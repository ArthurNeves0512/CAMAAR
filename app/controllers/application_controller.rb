class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :matricula])
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Acesso não autorizado!" unless current_user.admin?
  end
end
