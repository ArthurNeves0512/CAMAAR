class QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_questionnaire, only: [ :show ]

  def show
    @questions = @questionnaire.questions
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find_by(id: params[:id])
    unless @questionnaire
      redirect_to questionnaires_path, alert: "Questionário não encontrado."
    end
  end

  def questionnaire_params
    params.require(:questionnaire).permit(:name, :template_id, question_ids: [])
  end
end
