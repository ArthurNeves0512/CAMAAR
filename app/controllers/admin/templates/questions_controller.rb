class Admin::Templates::QuestionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :set_template
    before_action :set_question, only: [:edit, :update, :destroy]
  
    # Ação para criar uma nova questão
    def new
      @question = @template.questions.new
    end
  
    # Ação para editar uma questão
    def edit
    end
  
    # Ação para salvar a nova questão
    def create
      @question = @template.questions.new(question_params)
      if @question.save
        redirect_to admin_template_path(@template), notice: "Questão criada com sucesso!" # Ajuste para redirecionar para o template
      else
        flash.now[:alert] = "Erro ao criar a questão."
        render :new
      end
    end
  
    # Ação para atualizar uma questão existente
    def update
      if @question.update(question_params)
        redirect_to edit_admin_template_question_path(@template, @question), notice: "Questão atualizada com sucesso!" # Ajuste para redirecionar para a edição da questão
      else
        flash.now[:alert] = "Erro ao atualizar a questão."
        render :edit
      end
    end
  
    # Ação para excluir uma questão
    def destroy
      if @question.destroy
        redirect_to admin_template_path(@template), notice: "Questão excluída com sucesso!" # Ajuste para redirecionar para o template
      else
        redirect_to admin_template_path(@template), alert: "Erro ao excluir a questão."
      end
    end
  
    private
  
    # Define o template com base no id da URL
    def set_template
      @template = Template.find(params[:template_id])
    end
  
    # Define a questão com base no id da URL
    def set_question
      @question = @template.questions.find_by(id: params[:id])
      unless @question
        redirect_to admin_template_path(@template), alert: "Questão não encontrada." # Redirecionamento para a página do template
      end
    end
  
    # Define os parâmetros permitidos para a criação e atualização das questões
    def question_params
      params.require(:question).permit(:name, :text, :question_type) # Incluído 'name' como no esquema do banco
    end
  end
  