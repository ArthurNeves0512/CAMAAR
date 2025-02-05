require 'csv'

class ReportsController < ApplicationController
  before_action :authenticate_admin!

  def export_to_csv
    # Encontre o questionário (formulário) para exportar
    questionnaire = Questionnaire.find(params[:id])  

    # Se o questionário não tiver respostas, mostre uma mensagem
    if questionnaire.answers.empty?
      flash[:alert] = "Este formulário não possui resultados para exportar."
      redirect_to admin_questionnaires_path
    else
      # Caso contrário, gere o CSV
      csv_data = generate_csv(questionnaire)

      # Envia o arquivo CSV para download
      send_data csv_data, filename: "relatorio_formulario_#{questionnaire.classroom_info}.csv", type: 'text/csv'
    end
  end

  private

  # Método de autenticação simples
  def authenticate_admin!
    user = User.find(current_user.id)
    unless user && user.role == 'admin'
      flash[:alert] = 'Você precisa ser um administrador para acessar essa página.'
      redirect_to authenticated_root_path
    end
  end

  # Método que gera o CSV
  def generate_csv(questionnaire)
    CSV.generate(headers: true) do |csv|
      # Cabeçalhos do CSV
      csv << ['Resposta ID', 'Nome do Usuário', 'Nome do Questionário', 'Pergunta', 'Resposta']

      # Coleta os resultados das respostas
      results = Answer
        .joins(:question)
        .where(questionnaire_id: questionnaire.id)  # Filtra respostas do questionário específico
        .joins("JOIN submissions ON submissions.questionnaire_id = answers.questionnaire_id")
        .joins("JOIN users ON submissions.user_id = users.id")
        .select(
          "answers.id AS answer_id, 
           users.nome AS user_name, 
           '#{questionnaire.name}' AS questionnaire_name, 
           questions.text AS question_text, 
           answers.value AS answer_value"
        )

      # Adiciona os dados ao CSV
      results.each do |result|
        csv << [result.answer_id, result.user_name, result.questionnaire_name, result.question_text, result.answer_value]
      end
    end
  end
end
