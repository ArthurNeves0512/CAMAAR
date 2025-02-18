# Controladora do painel administrativo.
#
# Responsável por exibir informações administrativas, como o total de questionários,
# templates e salas de aula.
#
# @!attribute [r] @questionnaires
#   @return [ActiveRecord::Relation] Coleção de todos os questionários do sistema.
#
# @!attribute [r] @templates
#   @return [ActiveRecord::Relation] Coleção de todos os templates do sistema.
#
# @!attribute [r] @classrooms
#   @return [ActiveRecord::Relation] Coleção de todas as salas de aula,
#     incluindo suas disciplinas e departamentos.
class Admin::DashboardController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar o painel.
  before_action :authenticate_user!
  
  # Garante que apenas administradores possam acessar o painel.
  before_action :authorize_admin!

  # Exibe o painel administrativo com dados agregados.
  #
  # @return [void]
  def index
    # Obtém todos os questionários.
    @questionnaires = Questionnaire.all
    
    # Obtém todos os templates.
    @templates = Template.all
    
    # Obtém todas as salas de aula, incluindo suas disciplinas e departamentos.
    @classrooms = Classroom.includes(subject: :department)
  end
end
