# Controladora de questões, responsável por gerenciar as ações de criação, edição, atualização e exclusão de questões em um formulário.
class Admin::Templates::QuestionsController < ApplicationController
  # Antes de executar qualquer ação, autentica o usuário.
  before_action :authenticate_user! 
  # Garante que apenas administradores possam acessar as ações da controladora.
  before_action :authorize_admin! 
  # Define o template com base no ID da URL antes de executar as ações.
  before_action :set_template 
  # Define a questão antes das ações de edição, atualização e exclusão.
  before_action :set_question, only: [:edit, :update, :destroy] 

  # Exibe o formulário para criar uma nova questão.
  #
  # @return [void] Não retorna valor explícito, mas renderiza o formulário para criar uma nova questão.
  # @effect Exibe o formulário para criação de uma nova questão associada ao template.
  def new
    @question = @template.questions.new
  end

  # Exibe o formulário para editar uma questão existente.
  #
  # @return [void] Não retorna valor explícito, mas renderiza o formulário para edição de uma questão existente.
  # @effect Exibe o formulário para editar uma questão associada ao template.
  def edit
  end

  # Cria uma nova questão associada ao template.
  #
  # @param [ActionController::Parameters] question_params Parâmetros da nova questão.
  # @return [void] Se a questão for salva com sucesso, redireciona para a página do template com uma mensagem de sucesso.
  #               Caso contrário, renderiza novamente o formulário de criação com uma mensagem de erro.
  # @effect Cria uma nova questão associada ao template e redireciona para a página do template ou exibe um erro.
  def create
    @question = @template.questions.new(question_params)
    if @question.save
      redirect_to admin_template_path(@template), notice: "Questão criada com sucesso!"
    else
      flash.now[:alert] = "Erro ao criar a questão."
      render :new
    end
  end

  # Atualiza uma questão existente.
  #
  # @param [ActionController::Parameters] question_params Parâmetros para atualização da questão.
  # @return [void] Se a atualização for bem-sucedida, redireciona para a edição da questão com uma mensagem de sucesso.
  #               Caso contrário, renderiza novamente o formulário de edição com uma mensagem de erro.
  # @effect Atualiza uma questão existente e redireciona para a página de edição ou exibe um erro.
  def update
    if @question.update(question_params)
      redirect_to edit_admin_template_question_path(@template, @question), notice: "Questão atualizada com sucesso!"
    else
      flash.now[:alert] = "Erro ao atualizar a questão."
      render :edit
    end
  end

  # Exclui uma questão existente.
  #
  # @return [void] Se a exclusão for bem-sucedida, redireciona para a página do template com uma mensagem de sucesso.
  #               Caso contrário, exibe uma mensagem de erro e mantém o usuário na mesma página.
  # @effect Exclui uma questão associada ao template e redireciona para a página do template ou exibe um erro.
  def destroy
    if @question.destroy
      redirect_to admin_template_path(@template), notice: "Questão excluída com sucesso!"
    else
      redirect_to admin_template_path(@template), alert: "Erro ao excluir a questão."
    end
  end

  private

  # Define o template com base no ID passado na URL.
  #
  # @effect Define a variável @template com o template correspondente ao ID passado na URL.
  def set_template
    @template = Template.find(params[:template_id])
  end

  # Busca a questão pelo ID associado ao template.
  #
  # @param [Integer] id ID da questão.
  # @return [void] Se a questão não for encontrada, redireciona para a página do template com uma mensagem de erro.
  # @effect Define a variável @question com a questão correspondente ao ID e redireciona com um erro caso não encontre.
  def set_question
    @question = @template.questions.find_by(id: params[:id])
    unless @question
      redirect_to admin_template_path(@template), alert: "Questão não encontrada."
    end
  end

  # Define os parâmetros permitidos para criação e atualização de questões.
  #
  # @return [ActionController::Parameters] Parâmetros permitidos para a questão.
  def question_params
    params.require(:question).permit(:name, :text, :question_type)
  end
end
