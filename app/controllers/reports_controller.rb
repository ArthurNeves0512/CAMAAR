require "csv"

# Handles report generation operations including CSV exports for questionnaire results
class ReportsController < ApplicationController
  before_action :authenticate_admin!

  # Método responsável por exportar os resultados de um questionário para um arquivo CSV
  # 
  # @param [Integer] id O ID do questionário a ser exportado
  # @return [File] Arquivo CSV contendo os resultados do questionário
  # @effect Gera e envia o arquivo CSV para o download, caso o questionário tenha respostas.
  # Se não houver respostas, exibe uma mensagem de alerta e redireciona para a página de resultados.
  def export_to_csv
    questionnaire = Questionnaire.find(params[:id])

    if questionnaire.answers.empty?
      handle_empty_questionnaire
    else
      send_csv_export(questionnaire)
    end
  end

  private

  def authenticate_admin!
    return if current_user&.admin?

    flash[:alert] = "Você precisa ser um administrador para acessar essa página."
    redirect_to authenticated_root_path
  end

  def handle_empty_questionnaire
    flash[:alert] = "Este formulário não possui resultados para exportar."
    redirect_to admin_results_path
  end

  def send_csv_export(questionnaire)
    csv_data = QuestionnaireCsvExporter.new(questionnaire).generate
    filename = "relatorio_formulario_#{questionnaire.classroom_info}.csv"

    send_data csv_data, filename: filename, type: "text/csv"
  end
end

# Service object to handle CSV generation for questionnaires
class QuestionnaireCsvExporter
  CSV_HEADERS = [ "Resposta ID", "Nome do Usuário", "Nome do Questionário", "Pergunta", "Resposta" ].freeze

  def initialize(questionnaire)
    @questionnaire = questionnaire
  end

  def generate
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      formatted_results.each { |result| csv << result }
    end
  end

  private

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

  def questionnaire_answers
    Answer.includes(:question, submission: :user)
          .where(questionnaire_id: @questionnaire.id)
  end
end
