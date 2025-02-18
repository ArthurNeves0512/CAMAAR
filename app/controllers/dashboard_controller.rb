class DashboardController < ApplicationController
  # Antes de executar qualquer ação, autentica o usuário.
  # Garante que o usuário esteja autenticado para acessar o dashboard.
  #
  # @return [void] Se o usuário não estiver autenticado, será redirecionado para a página de login.
  before_action :authenticate_user!

  # Exibe a página inicial do dashboard, listando todos os questionários.
  #
  # @return [void] Renderiza a página do dashboard com todos os questionários registrados.
  # @effect Exibe todos os questionários cadastrados no sistema.
  def index
    # Obtém todos os questionários registrados no banco de dados.
    @questionnaires = Questionnaire.all
  end
end
