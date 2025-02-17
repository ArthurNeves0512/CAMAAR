# app/models/submission.rb
#
# Modelo que representa uma submissão de um questionário feita por um usuário.
# Cada submissão está associada a um usuário (estudante ou participante) e a um questionário.
# Além disso, uma submissão pode ter várias respostas associadas.
#
# == Associações
#
# - +belongs_to :user+ - Indica que cada submissão pertence a um único usuário.
#   O usuário associado é o responsável por realizar a submissão do questionário.
#
# - +belongs_to :questionnaire+ - Indica que cada submissão pertence a um questionário específico.
#   Cada questionário representa um conjunto de perguntas que o usuário deve responder.
#
# - +has_many :answers+ - Indica que uma submissão pode ter várias respostas associadas a ela.
#   Cada resposta está vinculada a uma pergunta do questionário, representando a resposta do usuário.
#
# == Exemplo de código:
# submission = Submission.new(user: some_user, questionnaire: some_questionnaire)
# submission.save
#

class Submission < ApplicationRecord
  # Relacionamento com o modelo User
  belongs_to :user

  # Relacionamento com o modelo Questionnaire
  belongs_to :questionnaire

  # Relacionamento com o modelo Answer
  has_many :answers, dependent: :destroy
end
