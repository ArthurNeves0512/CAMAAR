class Admin::SubmissionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    
    def index
        @questionnaire = Questionnaire.find(params[:questionnaire_id])
        @submissions = @questionnaire.submissions.includes(:user)
    end

    def new
    end
    
    def show
    end
    
    def create
    end
  end