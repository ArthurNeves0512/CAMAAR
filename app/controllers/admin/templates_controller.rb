class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    begin
      @templates = Template.all
      @template = Template.new
      @show_modal = false
    rescue StandardError => e
      @templates=[]
      @template=Template.new
      flash.now[:alert] = "Não foi possível carregar os templates no momento. Tente novamente mais tarde: '#{e}'"
      render :index
    end
    
    
  end

  
  def edit
  end
  
  def update
    # Atualiza o template com os parâmetros do formulário
    begin
      @template.update(template_params)
      redirect_to admin_template_path(@template), notice: "Template atualizado com sucesso!"
    rescue StandardError => e
      flash.now[:alert]="Erro ao atualizar o template: '#{e}'" 
      render :edit
    end
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
    begin
      @template.destroy
      redirect_to admin_templates_path, notice: "Template excluído com sucesso!"
    rescue StandardError => e
      redirect_to admin_templates_path, alert: "Erro ao excluir o template: #{e.message}"
    end
  end
  

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(
      :name,
      :semester
    )
  end
end
