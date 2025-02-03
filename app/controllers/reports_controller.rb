
require 'csv'

class ReportsController < ApplicationController
    before_action :authenticate_admin!
  
    def export_to_csv
      # Encontre o questionário (formulário) para exportar
      questionnaire = Questionnaire.find(sessions[current_user_id])
  
      # Se o questionário não tiver respostas, mostre uma mensagem
      if questionnaire.answers.empty?
        flash[:alert] = "Este formulário não possui resultados para exportar."
        redirect_to home_path 
      end
  
      # Caso contrário, gere o CSV
      csv_data = generate_csv(questionnaire)
  
      # Envia o arquivo CSV para download
      send_data csv_data, filename: "relatorio_formulario_#{questionnaire.classroom_info}.csv", type: 'text/csv'
    end
  
    private
  
    # Método de autenticação simples
    def authenticate_admin!
      user = User.find(session[:current_user_id])
      unless user && user.admin == true
        redirect_to new_user_session_path, alert: 'Você precisa ser um administrador para acessar essa página.'
      end
    end
  
    # Método que gera o CSV
    def generate_csv(questionnaire)
      CSV.generate(headers: true) do |csv|
        # Cabeçalhos do CSV
        csv << ['  ID  ', '  Pergunta  ', '  Resposta  ']
  
        # Adiciona as respostas ao CSV
        questionnaire.answers.each do |answer|
          csv << [answer.id,answer.question.text, answer.value,answer]
        end
      end
    end
  end
  
end
