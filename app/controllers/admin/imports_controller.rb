# This controller handles import requests and delegates processing to the ImportService.
class Admin::ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def create
    unless params[:files].present?
      flash[:alert] = "Nenhum arquivo foi selecionado."
      redirect_to new_admin_import_path and return
    end

    import_service = ImportService.new(params[:files], params[:overwrite])
    if import_service.process
      redirect_to new_admin_import_path, notice: "✅ Dados importados com sucesso."
    else
      flash[:alert] = "❌ Erro de processamento."
      redirect_to new_admin_import_path
    end
  end
end
