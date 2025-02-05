class Admin::ImportsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    
    def new
    end
    
    def show
    end
    
    def create
    end
  end