class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    @templates = Template.all
    @template = Template.new
    @show_modal = false # Inicializa como false, só será true se houver erro na criação
  end

  def update
    # Atualiza o template com os parâmetros do formulário
    if @template.update(template_params)
      redirect_to admin_template_path(@template), notice: "Template atualizado com sucesso!"
    else
      render :edit, alert: "Erro ao atualizar o template."
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
    @template.destroy
    redirect_to admin_templates_path, notice: "Template excluído com sucesso!"
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
