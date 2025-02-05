class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @questionnaires = Questionnaire.all
  end
end