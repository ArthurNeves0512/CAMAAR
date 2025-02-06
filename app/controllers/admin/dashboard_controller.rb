class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    # Dados administrativos (ex: total de questionários)
    @questionnaires = Questionnaire.all
    @templates = Template.all
    @classrooms = Classroom.includes(subject: :department)
  end

end