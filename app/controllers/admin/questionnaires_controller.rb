# Controladora responsável pelas ações de criação e visualização de formulários (questionários)
class Admin::QuestionnairesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  protect_from_forgery with: :exception

  # Método responsável por listar todos os questionários, templates e salas de aula
  #
  # @return [Hash] Retorna um objeto JSON com os questionários, templates e salas de aula.
  # @effect Renderiza um JSON com os dados dos questionários, templates e salas de aula.
  def index
    @questionnaires = Questionnaire.all
    @templates = Template.all
    @classrooms = Classroom.includes(subject: :department)

    # Retorna um JSON com os questionários, templates e salas de aula
    render json: {
      questionnaires: @questionnaires,
      templates: @templates,
      classrooms: @classrooms
    }
  end

  # Método responsável por criar um novo questionário a partir de um template e salas de aula
  #
  # @param [Integer] template_id ID do template utilizado para criar o questionário.
  # @param [Array] classroom_codes Códigos das salas de aula associadas ao questionário.
  # @param [String] name Nome do questionário a ser criado.
  # @return [void] Retorna nada, mas realiza redirecionamentos baseados no sucesso ou falha da criação.
  # @effect Cria o questionário no banco de dados e redireciona com uma mensagem de sucesso ou erro.
  def create
    template_id = params[:template_id]
    classroom_codes = params[:classroom_codes]
    classroom_codes = classroom_codes.is_a?(Array) ? classroom_codes : []
    questionnaire_name = params[:name]

    @questionnaire = Questionnaire.new(
      name: questionnaire_name,
      template_id: template_id,
      classroom_info: classroom_codes.join(",")
    )

    if @questionnaire.save
      # Redireciona para a view raiz do admin com uma mensagem de sucesso
      redirect_to admin_root_path, notice: "✅ Formulários criados com sucesso."
    else
      # Redireciona para a view raiz do admin com uma mensagem de erro
      redirect_to admin_root_path, alert: "❌ Erro de processamento."
    end
  end

  # Método responsável por exibir os detalhes de um questionário específico
  #
  # @param [Integer] id ID do questionário a ser exibido.
  # @return [Hash] Retorna o questionário específico em formato JSON.
  # @effect Renderiza o questionário no formato JSON.
  def show
    @questionnaire = Questionnaire.find(params[:id])

    # Retorna o questionário no formato JSON
    render json: @questionnaire
  end
end
