require "csv"

# Controladora de relatórios, responsável pela geração de relatórios, incluindo exportação de dados em formato CSV para resultados de questionários.
class ReportsController < ApplicationController
  # Garante que apenas administradores possam acessar as ações da controladora.
  before_action :authenticate_admin!

  # Exporta os resultados de um questionário para um arquivo CSV.
  #
  # @return [void] Envia um arquivo CSV com os dados do questionário ou redireciona com uma mensagem de alerta, caso não haja resultados.
  # @effect Gera e envia um arquivo CSV com os dados do questionário ou lida com a situação onde o questionário não possui resultados.
  def export_to_csv
    questionnaire = Questionnaire.find(params[:id])

    if questionnaire.answers.empty?
      handle_empty_questionnaire
    else
      send_csv_export(questionnaire)
    end
  end

  private

  # Verifica se o usuário atual é um administrador.
  #
  # @effect Redireciona o usuário para a página inicial com uma mensagem de alerta caso o usuário não seja administrador.
  def authenticate_admin!
    return if current_user&.admin?

    flash[:alert] = "Você precisa ser um administrador para acessar essa página."
    redirect_to authenticated_root_path
  end

  # Lida com a situação em que o questionário não possui respostas.
  #
  # @effect Exibe uma mensagem de alerta e redireciona para a página de resultados do administrador.
  def handle_empty_questionnaire
    flash[:alert] = "Este formulário não possui resultados para exportar."
    redirect_to admin_results_path
  end

  # Envia o arquivo CSV contendo os resultados do questionário.
  #
  # @param [Questionnaire] questionnaire O questionário cujos resultados serão exportados.
  # @return [void] Envia os dados em formato CSV para download.
  # @effect Gera um arquivo CSV com os resultados do questionário e envia para o navegador do usuário.
  def send_csv_export(questionnaire)
    csv_data = QuestionnaireCsvExporter.new(questionnaire).generate
    filename = "relatorio_formulario_#{questionnaire.classroom_info}.csv"

    send_data csv_data, filename: filename, type: "text/csv"
  end
end

# Objeto de serviço para gerar arquivos CSV com os dados de um questionário.
class QuestionnaireCsvExporter
  # Cabeçalhos que serão usados no arquivo CSV.
  CSV_HEADERS = [ "Resposta ID", "Nome do Usuário", "Nome do Questionário", "Pergunta", "Resposta" ].freeze

  # Inicializa o exportador com o questionário.
  #
  # @param [Questionnaire] questionnaire O questionário que contém as respostas a serem exportadas.
  def initialize(questionnaire)
    @questionnaire = questionnaire
  end

  # Gera os dados CSV com base nas respostas do questionário.
  #
  # @return [String] Os dados do questionário no formato CSV.
  # @effect Gera um arquivo CSV com os resultados das respostas do questionário.
  def generate
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      formatted_results.each { |result| csv << result }
    end
  end

  private

  # Formata as respostas para exportação.
  #
  # @return [Array<Array>] Um array de arrays, onde cada sub-array representa uma linha de dados no CSV.
  # @effect Formata as respostas para correspondem à estrutura do arquivo CSV.
  def formatted_results
    questionnaire_answers.map do |answer|
      [
        answer.id,
        answer.submission.user.nome,
        @questionnaire.name,
        answer.question.text,
        answer.value
      ]
    end
  end

  # Busca as respostas relacionadas ao questionário.
  #
  # @return [ActiveRecord::Relation] As respostas do questionário, incluindo as perguntas e os usuários que as responderam.
  def questionnaire_answers
    Answer.includes(:question, submission: :user)
          .where(questionnaire_id: @questionnaire.id)
  end
end
