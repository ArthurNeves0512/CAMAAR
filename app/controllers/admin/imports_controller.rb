# app/controllers/admin/imports_controller.rb

# Controlador responsável pelo gerenciamento de importações de dados.
# Este controlador lida com as requisições de importação de arquivos e delega o processamento
# para o serviço de importação, retornando a resposta apropriada para o usuário.
#
# Ele exige que o usuário esteja autenticado e seja um administrador para realizar a importação.
class Admin::ImportsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar qualquer ação.
  before_action :authenticate_user!

  # Garante que o usuário tenha permissões de administrador antes de acessar qualquer ação.
  before_action :authorize_admin!

  # Cria uma nova importação a partir dos arquivos enviados.
  #
  # Este método verifica se arquivos foram selecionados e, caso contrário, redireciona
  # o usuário de volta à página de importação com uma mensagem de alerta.
  # Se os arquivos estiverem presentes, o processo de importação é delegado ao
  # serviço de importação. O método também trata os resultados do processamento,
  # exibindo uma mensagem de sucesso ou erro ao usuário.
  #
  # @return [void] Este método realiza um redirecionamento com base no resultado do processamento.
  #
  # Exemplo:
  #   POST /admin/imports
  #   params: { files: [...], overwrite: true }
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
