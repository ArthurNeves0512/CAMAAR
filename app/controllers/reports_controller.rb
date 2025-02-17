require "csv"

class ReportsController < ApplicationController
  before_action :authenticate_admin!

  # Método responsável por exportar os resultados de um questionário para um arquivo CSV
  # 
  # @param [Integer] id O ID do questionário a ser exportado
  # @return [File] Arquivo CSV contendo os resultados do questionário
  # @effect Gera e envia o arquivo CSV para o download, caso o questionário tenha respostas.
  # Se não houver respostas, exibe uma mensagem de alerta e redireciona para a página de resultados.
  def export_to_csv
    # Encontra o questionário com base no ID passado na URL
    questionnaire = Questionnaire.find(params[:id])

    # Se o questionário não tiver respostas, mostra uma mensagem de alerta e redireciona
    if questionnaire.answers.empty?
      flash[:alert] = "Este formulário não possui resultados para exportar."
      redirect_to admin_results_path
    else
      # Caso contrário, gera o CSV com as respostas
      csv_data = generate_csv(questionnaire)

      # Envia o arquivo CSV para download com o nome baseado no questionário
      send_data csv_data, filename: "relatorio_formulario_#{questionnaire.classroom_info}.csv", type: "text/csv"
    end
  end

  private

  # Método de autenticação simples para garantir que apenas administradores possam acessar a funcionalidade
  #
  # @effect Redireciona o usuário para a página inicial autenticada se não for um administrador
  def authenticate_admin!
    user = User.find(current_user.id)
    unless user && user.role == "admin"
      flash[:alert] = "Você precisa ser um administrador para acessar essa página."
      redirect_to authenticated_root_path
    end
  end

  # Método responsável por gerar o arquivo CSV com as respostas do questionário
  #
  # @param [Questionnaire] questionnaire O questionário cujas respostas serão exportadas
  # @return [String] O conteúdo do arquivo CSV gerado
  def generate_csv(questionnaire)
    # Gera o CSV com cabeçalhos e os dados das respostas
    CSV.generate(headers: true) do |csv|
      # Cabeçalhos do CSV
      csv << ["Resposta ID", "Nome do Usuário", "Nome do Questionário", "Pergunta", "Resposta"]

      # Coleta os resultados das respostas para o questionário
      results = Answer
        .joins(:question) # Joga a tabela de respostas com a tabela de perguntas
        .where(questionnaire_id: questionnaire.id) # Filtra respostas do questionário específico
        .joins("JOIN submissions ON submissions.questionnaire_id = answers.questionnaire_id") # Junta a tabela de submissões
        .joins("JOIN users ON submissions.user_id = users.id") # Junta a tabela de usuários
        .select(
          "answers.id AS answer_id,
           users.nome AS user_name,
           '#{questionnaire.name}' AS questionnaire_name,
           questions.text AS question_text,
           answers.value AS answer_value"
        )

      # Adiciona cada resultado ao CSV
      results.each do |result|
        csv << [result.answer_id, result.user_name, result.questionnaire_name, result.question_text, result.answer_value]
      end
    end
  end
end
