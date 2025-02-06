class HomeController < ApplicationController
  def index
    @questionnaires = Questionnaire.all # Busca todos os questionários
  end
end
