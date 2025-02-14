class Admin::SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_questionnaire, only: [:index]

  def index
    @submissions = @questionnaire.submissions.includes(:user, answers: :question)
  end

  def show
    @submission = Submission.includes(:user, answers: :question).find(params[:id])
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_dashboard_path, alert: "Questionário não encontrado."
  end
end
