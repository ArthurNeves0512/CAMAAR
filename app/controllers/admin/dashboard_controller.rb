class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    # Dados administrativos (ex: total de questionários)
    @questionnaires = Questionnaire.all
  end

end