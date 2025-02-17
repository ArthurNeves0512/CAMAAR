class Admin::TemplatesController < ApplicationController
  # Antes de executar qualquer ação, autentica o usuário.
  before_action :authenticate_user!
  # Garante que apenas administradores possam acessar as ações da controladora.
  before_action :authorize_admin!
  # Define o template com base no ID da URL antes de executar as ações 'show', 'edit', 'update' e 'destroy'.
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # Exibe todos os templates e o formulário para criar um novo template.
  #
  # @return [void] Renderiza a página com todos os templates e um formulário para criar um novo template.
  # @effect Exibe os templates e, caso ocorra um erro, exibe uma mensagem de erro.
  def index
    begin
      @templates = Template.all
      @template = Template.new
      @show_modal = false
    rescue StandardError => e
      @templates = []
      @template = Template.new
      flash.now[:alert] = "Não foi possível carregar os templates no momento. Tente novamente mais tarde: '#{e}'"
      render :index
    end
  end

  # Exibe o formulário para editar um template existente.
  #
  # @return [void] Renderiza a página de edição do template.
  def edit
  end

  # Atualiza um template existente.
  #
  # @return [void] Se a atualização for bem-sucedida, redireciona para a página de exibição do template com uma mensagem de sucesso.
  # Caso contrário, exibe uma mensagem de erro e renderiza novamente o formulário de edição.
  def update
    # Atualiza o template com os parâmetros do formulário
    # @param[ActionController::Parameters] template_params parametros gerados pelo metodo template_params
    begin
      @template.update(template_params)
      redirect_to admin_template_path(@template), notice: "Template atualizado com sucesso!"
    rescue StandardError => e
      flash.now[:alert] = "Erro ao atualizar o template: '#{e}'"
      render :edit
    end
  end

  # Cria um novo template.
  #
  # @return [void] Se o template for criado com sucesso, redireciona para a página de templates com uma mensagem de sucesso.
  # Caso contrário, exibe uma mensagem de erro e renderiza novamente a página de index com um formulário para criar um template.
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

  # Exclui um template existente.
  #
  # @return [void] Se a exclusão for bem-sucedida, redireciona para a página de templates com uma mensagem de sucesso.
  # Caso contrário, exibe uma mensagem de erro e redireciona para a mesma página.
  def destroy
    begin
      @template.destroy
      redirect_to admin_templates_path, notice: "Template excluído com sucesso!"
    rescue StandardError => e
      redirect_to admin_templates_path, alert: "Erro ao excluir o template: #{e.message}"
    end
  end

  private

  # Define o template com base no ID passado na URL.
  #
  # @effect Define a variável @template com o template correspondente ao ID passado na URL.
  def set_template
    @template = Template.find(params[:id])
  end

  # Define os parâmetros permitidos para criação e atualização de templates.
  #
  # @return [ActionController::Parameters] Parâmetros permitidos para o template.
  def template_params
    params.require(:template).permit(
      :name,
      :semester
    )
  end
end
