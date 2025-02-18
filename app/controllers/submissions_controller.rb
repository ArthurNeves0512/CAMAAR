class SubmissionsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar as ações.
  before_action :authenticate_user!
  # Define o questionário com base no ID passado na URL antes de executar a ação de criação.
  before_action :set_questionnaire, only: [:create]

  # Cria uma nova submissão de avaliação, associando as respostas ao questionário.
  #
  # @return [void] Se a submissão for salva com sucesso, redireciona para a página inicial com uma mensagem de sucesso.
  #               Caso contrário, exibe uma mensagem de erro e renderiza novamente o formulário de submissão.
  # @effect Cria uma nova submissão de avaliação associada ao questionário, processa as respostas e salva as respostas no banco de dados.
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

  # Define o questionário com base no ID passado na URL.
  #
  # @effect Define a variável @questionnaire com o questionário correspondente ao ID passado na URL.
  #         Se o questionário não for encontrado, redireciona o usuário para a página inicial com uma mensagem de erro.
  def set_questionnaire
    @questionnaire = Questionnaire.find_by(id: params[:questionnaire_id])
    redirect_to root_path, alert: "Questionário não encontrado." if @questionnaire.nil?
  end

  # Permite os parâmetros necessários para criar uma submissão e suas respostas.
  #
  # @return [ActionController::Parameters] Parâmetros permitidos para a submissão e suas respostas.
  def submission_params
    params.require(:submission).permit(:questionnaire_id, answers: {})
  end
end
