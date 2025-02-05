
class QuestionnairesController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @questionnaires = Questionnaire.all
    end
  
    def show
      @questionnaire = Questionnaire.find(params[:id])
    end
  
    # Adicione ações new, create, edit, update, destroy conforme necessário
  end