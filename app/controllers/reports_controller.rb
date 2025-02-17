require "csv"

# Controlador responsável por operações de geração de relatórios, incluindo exportação de resultados de questionários para CSV.
class ReportsController < ApplicationController
  before_action :authenticate_admin!

  # Exporta os resultados de um questionário para um arquivo CSV.
  #
  # @param [Integer] id O ID do questionário a ser exportado.
  # @return [File] Arquivo CSV contendo os resultados do questionário.
  # @effect Se o questionário tiver respostas, gera e envia o arquivo CSV para download.
  #         Caso contrário, exibe uma mensagem de alerta e redireciona para a página de resultados.
  def export_to_csv
    questionnaire = Questionnaire.find(params[:id])

    if questionnaire.answers.empty?
      handle_empty_questionnaire
    else
      send_csv_export(questionnaire)
    end
  end

  private

  # Garante que apenas administradores tenham acesso à ação de exportação.
  #
  # @effect Se o usuário não for um administrador, exibe uma mensagem de alerta e redireciona.
  def authenticate_admin!
    return if current_user&.admin?

    flash[:alert] = "Você precisa ser um administrador para acessar essa página."
    redirect_to authenticated_root_path
  end

  # Lida com a exportação de questionários sem respostas.
  #
  # @effect Exibe uma mensagem de alerta e redireciona para a página de resultados administrativos.
  def handle_empty_questionnaire
    flash[:alert] = "Este formulário não possui resultados para exportar."
    redirect_to admin_results_path
  end

  # Gera e envia um arquivo CSV contendo os resultados do questionário.
  #
  # @param [Questionnaire] questionnaire O questionário cujas respostas serão exportadas.
  # @return [File] O arquivo CSV gerado.
  def send_csv_export(questionnaire)
    csv_data = QuestionnaireCsvExporter.new(questionnaire).generate
    filename = "relatorio_formulario_#{questionnaire.classroom_info}.csv"

    send_data csv_data, filename: filename, type: "text/csv"
  end
end

# Classe de serviço responsável por gerar arquivos CSV contendo os resultados de um questionário.
class QuestionnaireCsvExporter
  # Cabeçalhos do arquivo CSV gerado.
  CSV_HEADERS = ["Resposta ID", "Nome do Usuário", "Nome do Questionário", "Pergunta", "Resposta"].freeze

  # Inicializa a classe com um questionário.
  #
  # @param [Questionnaire] questionnaire O questionário cujos resultados serão exportados.
  def initialize(questionnaire)
    @questionnaire = questionnaire
  end

  # Gera o conteúdo CSV formatado.
  #
  # @return [String] O conteúdo do arquivo CSV gerado.
  def generate
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      formatted_results.each { |result| csv << result }
    end
  end

  private

  # Retorna os resultados formatados para inserção no CSV.
  #
  # @return [Array<Array>] Lista de arrays representando as linhas do CSV.
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

  # Busca as respostas do questionário otimizando as consultas com includes.
  #
  # @return [ActiveRecord::Relation] As respostas do questionário com associações carregadas.
  def questionnaire_answers
    Answer.includes(:question, submission: :user)
          .where(questionnaire_id: @questionnaire.id)
  end
end
