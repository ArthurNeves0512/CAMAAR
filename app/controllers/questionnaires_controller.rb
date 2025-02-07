class QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_questionnaire, only: [:show, :edit, :update, :destroy]

  def index
    @questionnaires = Questionnaire.all
  end

  def show
    @questions = @questionnaire.questions
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    if @questionnaire.save
      redirect_to @questionnaire, notice: "Questionário criado com sucesso."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @questionnaire.update(questionnaire_params)
      redirect_to @questionnaire, notice: "Questionário atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @questionnaire.destroy
    redirect_to questionnaires_path, notice: "Questionário excluído com sucesso."
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
