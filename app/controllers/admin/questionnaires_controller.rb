class Admin::QuestionnairesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    
    protect_from_forgery with: :exception
    
    def index
      @questionnaires = Questionnaire.all
      @templates = Template.all
      @classrooms = Classroom.includes(subject: :department)
      render json: {
        questionnaires: @questionnaires,
        templates: @templates,
        classrooms: @classrooms
      }
    end
    
    def create
      template_id = params[:template_id]
      classroom_codes = params[:classroom_codes]
      # Se classroom_codes não for um Array, define como array vazio
      classroom_codes = classroom_codes.is_a?(Array) ? classroom_codes : []
      questionnaire_name = params[:name]
      
      @questionnaire = Questionnaire.new(
        name: questionnaire_name,
        template_id: template_id,
        classroom_info: classroom_codes.join(",")
      )
      
      if @questionnaire.save
        classroom_codes.each do |code|
          # Aqui você pode associar as turmas, se necessário
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
      render json: @questionnaire
    end
  end
  