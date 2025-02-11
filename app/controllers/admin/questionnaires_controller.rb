class Admin::QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  protect_from_forgery with: :exception

  def index
    @questionnaires = Questionnaire.all
    @templates = Template.all
    @classrooms = Classroom.includes(subject: :department)
  end

  def create
    template_id = params[:template_id]
    classroom_codes = params[:classroom_codes]
    questionnaire_name = params[:name] # Obtém o nome do questionário

    @questionnaire = Questionnaire.new(
      name: questionnaire_name, # Salva o nome no banco
      template_id: template_id,
    )

    if @questionnaire.save
      classroom_codes.each do |code|
        # classroom = Classroom.find_by(code: code)
        # Associe as turmas, se necessário
      end
      flash[:notice] = "✅ Formulários criados com sucesso!"
      render json: { success: true }
    else
      flash[:alert] = "❌ Erro ao criar formulário"
      render json: { success: false, message: flash[:alert] }
    end
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
  end
end
