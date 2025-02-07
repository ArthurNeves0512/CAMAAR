class SubmissionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_questionnaire, only: [:create]
  
    def create
      # Removemos a chave :answers ao construir a submissão
      submission_data = submission_params.except(:answers)
      @submission = @questionnaire.submissions.build(submission_data)
      @submission.user = current_user
  
      if @submission.save
        # Cria cada registro de Answer individualmente
        (submission_params[:answers] || {}).each do |question_id, value|
          Answer.create(
            question_id: question_id,
            value: value,
            questionnaire_id: @questionnaire.id
          )
        end
  
        redirect_to root_path, notice: "Avaliação enviada com sucesso!"
      else
        flash[:alert] = "Erro ao enviar a avaliação. Verifique suas respostas."
        render "questionnaires/show"
      end
    end
  
    private
  
    def set_questionnaire
      @questionnaire = Questionnaire.find(params[:questionnaire_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Questionário não encontrado."
    end
  
    def submission_params
      params.require(:submission).permit(:questionnaire_id, answers: {})
    end
  end
  