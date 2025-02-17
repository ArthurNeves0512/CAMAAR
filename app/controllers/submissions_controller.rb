class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_questionnaire, only: [:create]

  def create
    @submission = @questionnaire.submissions.build(user: current_user)

    if @submission.save
      submission_params[:answers].each do |question_id, value|
        question = Question.find_by(id: question_id)

        # Ignora perguntas inválidas
        next if question.nil?

        # Criação das respostas sem verificar as opções (para múltipla escolha)
        if question.question_type.casecmp("Múltipla escolha").zero?
          # Salva diretamente o valor da opção escolhida
          @submission.answers.create(
            question: question,
            value: value,  # O valor é o texto da opção
            questionnaire: @questionnaire,
          )
        else
          # Criação para perguntas dissertativas
          @submission.answers.create(
            question: question,
            value: value,
            questionnaire: @questionnaire,
          )
        end
      end

      redirect_to root_path, notice: "Avaliação enviada com sucesso!"
    else
      flash[:alert] = "Erro ao enviar a avaliação. Verifique suas respostas."
      render "questionnaires/show"
    end
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find_by(id: params[:questionnaire_id])
    redirect_to root_path, alert: "Questionário não encontrado." if @questionnaire.nil?
  end

  def submission_params
    params.require(:submission).permit(:questionnaire_id, answers: {})
  end
end
