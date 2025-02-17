class Admin::ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @submissions = Submission.all
    @questionnaires = Questionnaire.all
    @templates = Template.all
    @classrooms = Classroom.includes(subject: :department)
    @answers = Answer.all
  end

end
