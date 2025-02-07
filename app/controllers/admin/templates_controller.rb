class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    @templates = Template.all
    @template = Template.new
    @show_modal = false # Inicializa como false, só será true se houver erro na criação
  end

  def edit
    @template = Template.find(params[:id])
    render :edit
  end

  def new
    render :new
  end

  def destroy
    @template = Template.find(params[:id])
  end

  def show
    # Exibe o template, já carregado pela ação set_template
    @questions = @template.questions
  end

  def edit
    # O template para edição já é carregado pelo before_action :set_template
    @questions = @template.questions
  end

  def update
    # Atualiza o template com os parâmetros do formulário
    if @template.update(template_params)
      redirect_to admin_template_path(@template), notice: "Template atualizado com sucesso!"
    else
      render :edit, alert: "Erro ao atualizar o template."
    end
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to admin_templates_path, notice: "Template criado com sucesso!"
    else
      flash.now[:alert] = "Erro ao criar o template."
      @templates = Template.all
      @show_modal = true
      render :index
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_templates_path, notice: "Template excluído com sucesso!"
  end

  # Ação para criar uma nova questão
  def new_question
    @question = @template.questions.new
  end

  # Ação para salvar a nova questão
  def create_question
    @question = @template.questions.new(question_params)
    if @question.save
      redirect_to edit_admin_template_path(@template), notice: "Questão criada com sucesso!"
    else
      render :new_question, alert: "Erro ao criar a questão."
    end
  end

  # Ação para excluir uma questão
  def destroy_question
    @question = @template.questions.find(params[:question_id])
    @question.destroy
    redirect_to edit_admin_template_path(@template), notice: "Questão excluída com sucesso!"
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :semester, :target_audience) # Permite os parâmetros do formulário do template
  end

  def question_params
    params.require(:question).permit(:text, :question_type) # Permite os parâmetros do formulário de questão
  end
end
