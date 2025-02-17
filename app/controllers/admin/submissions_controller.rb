# Controladora de submissões, responsável por listar as submissões de um questionário e exibir detalhes de uma submissão específica.
class Admin::SubmissionsController < ApplicationController
  # Antes de executar qualquer ação, autentica o usuário.
  before_action :authenticate_user!
  # Garante que apenas administradores possam acessar as ações da controladora.
  before_action :authorize_admin!
  # Define o questionário com base no ID da URL antes de executar a ação 'index'.
  before_action :set_questionnaire, only: [:index]

  # Exibe todas as submissões relacionadas a um questionário.
  #
  # @return [void] Renderiza a página de submissões com todas as submissões relacionadas ao questionário.
  # @effect Exibe a lista de submissões com os usuários e respostas associadas.
  def index
    @submissions = @questionnaire.submissions.includes(:user, answers: :question)
  end

  # Exibe os detalhes de uma submissão específica.
  # @param [integer] id da submissao
  # @return [void] Renderiza a página com os detalhes da submissão selecionada, incluindo o usuário e suas respostas.
  # @effect Exibe os detalhes de uma submissão com as respostas associadas.
  def show
    @submission = Submission.includes(:user, answers: :question).find(params[:id])
  end

  private

  # Define o questionário com base no ID passado na URL.
  #
  # @effect Define a variável @questionnaire com o questionário correspondente ao ID passado na URL, caso o questionário não seja encontrado, ocorre um redirecionamento para a view de dashboard de admin com uma mensagem de erro.
  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_dashboard_path, alert: "Questionário não encontrado."
  end
end
