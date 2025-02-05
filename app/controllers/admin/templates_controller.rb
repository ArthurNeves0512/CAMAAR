class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  
  def index
    @templates = Template.all
  end
  
  def show
    @template = Template.find(params[:id])
  end
  
end