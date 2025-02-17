class HomeController < ApplicationController
  # Exibe a página inicial da aplicação, listando todos os questionários.
  #
  # @return [void] Renderiza a página inicial com todos os questionários registrados.
  # @effect Exibe todos os questionários cadastrados no sistema na página inicial.
  def index
    # Obtém todos os questionários registrados no banco de dados.
    @questionnaires = Questionnaire.all
  end
end
