class Admin::QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  
  def index
    @questionnaires = Questionnaire.all
  end
  
  def show
    @questionnaire = Questionnaire.find(params[:id])
  end

end