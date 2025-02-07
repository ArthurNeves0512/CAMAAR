class Admin::QuestionsController < ApplicationController
    before_action :set_template
  
    def new
      @question = @template.questions.new
    end
  
    def create
      @question = @template.questions.new(question_params)
      if @question.save
        redirect_to edit_admin_template_path(@template), notice: "Questão criada com sucesso."
      else
        render :new
      end
    end
  
    private
  
    def set_template
      @template = Template.find(params[:template_id])
    end
  
    def question_params
      params.require(:question).permit(:text, :question_type)
    end
  end
  