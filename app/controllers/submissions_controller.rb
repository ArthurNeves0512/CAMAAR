class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_questionnaire, only: [:create]

  # Método responsável por criar uma submissão de respostas para um questionário
  #
  # @return [void] Redireciona para a página inicial com uma mensagem de sucesso ou renderiza novamente
  #               a página do questionário com uma mensagem de erro.
  # @effect Cria a submissão e as respostas associadas, dependendo do tipo de pergunta (Múltipla Escolha ou Dissertativa).
  def create
    # Cria a submissão associada ao questionário e ao usuário atual
    # @param[integer] current_user id do usuario atual do sistema
    @submission = @questionnaire.submissions.build(user: current_user)

    # Tenta salvar a submissão
    if @submission.save
      # Itera sobre as respostas enviadas pelo usuário
      submission_params[:answers].each do |question_id, value|
        question = Question.find_by(id: question_id)

        # Ignora perguntas inválidas (não encontradas)
        next if question.nil?

        # Lógica para criação das respostas, dependendo do tipo de pergunta
        if question.question_type.casecmp("Múltipla escolha").zero?
          # Para perguntas do tipo "Múltipla escolha", salva diretamente o valor da opção escolhida
          @submission.answers.create(
            question: question,
            value: value,  # O valor é o texto da opção escolhida
            questionnaire: @questionnaire,
          )
        else
          # Para perguntas dissertativas, salva o valor como resposta livre
          @submission.answers.create(
            question: question,
            value: value,
            questionnaire: @questionnaire,
          )
        end
      end

      # Redireciona para a página inicial com uma mensagem de sucesso
      redirect_to root_path, notice: "Avaliação enviada com sucesso!"
    else
      # Se ocorrer um erro ao salvar a submissão, exibe uma mensagem de erro e renderiza a página do questionário
      flash[:alert] = "Erro ao enviar a avaliação. Verifique suas respostas."
      render "questionnaires/show"
    end
  end

  private

  # Método que define o questionário com base no ID passado na URL
  #
  # @effect Define a variável @questionnaire com o questionário correspondente ao ID passado na URL
  #         ou redireciona para a página inicial caso o questionário não seja encontrado.
  def set_questionnaire
    @questionnaire = Questionnaire.find_by(id: params[:questionnaire_id])
    redirect_to root_path, alert: "Questionário não encontrado." if @questionnaire.nil?
  end

  # Método que permite os parâmetros para criação de submissões e respostas
  #
  # @return [ActionController::Parameters] Parâmetros permitidos para a submissão, incluindo o ID do questionário e as respostas.
  def submission_params
    params.require(:submission).permit(:questionnaire_id, answers: {})
  end
end
