# Controladora de resultados, responsável por fazer o link das tabelas de questionários, templates, turmas, respostas de formulário
class Admin::ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  # Método responsável por listar todos os questionários, templates, turmas, respostas e submissões para gerar os resultados
  #
  # @return [void] Não retorna valor explícito, mas renderiza a página com os dados necessários para gerar os resultados.
  # @effect Carrega os dados de questionários, templates, turmas, respostas e submissões para visualização na página de resultados.
  def index
    @submissions = Submission.all
    @questionnaires = Questionnaire.all
    @templates = Template.all
    @classrooms = Classroom.includes(subject: :department)
    @answers = Answer.all
  end
end
