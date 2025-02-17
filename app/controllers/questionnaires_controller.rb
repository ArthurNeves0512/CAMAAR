class QuestionnairesController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar as ações.
  before_action :authenticate_user!
  # Define o questionário antes de acessar a ação 'show'.
  before_action :set_questionnaire, only: [:show]

  # Exibe os detalhes de um questionário específico, incluindo suas questões.
  #
  # @return [void] Renderiza a página com o questionário e suas questões associadas.
  # @effect Exibe as questões associadas ao questionário selecionado.
  def show
    # Obtém as questões associadas ao questionário selecionado.
    @questions = @questionnaire.questions
  end

  private

  # Define o questionário com base no ID passado na URL.
  #
  # @effect Define a variável @questionnaire com o questionário correspondente ao ID passado na URL.
  # @param[integer] id do questionario
  # Caso o questionário não seja encontrado, redireciona para a lista de questionários com uma mensagem de erro.
  def set_questionnaire
    @questionnaire = Questionnaire.find_by(id: params[:id])
    unless @questionnaire
      redirect_to questionnaires_path, alert: "Questionário não encontrado."
    end
  end

  # Define os parâmetros permitidos para criação e atualização de questionários.
  #
  # @return [ActionController::Parameters] Parâmetros permitidos para o questionário.
  def questionnaire_params
    params.require(:questionnaire).permit(:name, :template_id, question_ids: [])
  end
end
