# app/models/answer.rb
#
# Modelo que representa as respostas fornecidas pelos usuários para as questões de um questionário.
# Cada resposta está associada a uma pergunta, um questionário e uma submissão.
#
# As respostas podem ser de diferentes tipos, como dissertativas ou de múltipla escolha, dependendo
# do tipo de pergunta associada.
#
# == Associações
#
# - +belongs_to :question+ - Cada resposta está associada a uma pergunta.
# - +belongs_to :questionnaire+ - Cada resposta pertence a um questionário.
# - +belongs_to :submission+ - Cada resposta pertence a uma submissão, que representa o envio do questionário por um usuário.
#
# == Validações
#
# Validações podem ser aplicadas para garantir que as respostas sejam válidas. Exemplo:
#
# - A presença da resposta e do question_id podem ser validadas.
#
#
# == Classe Answer
#
# A classe Answer representa as respostas de um questionário, cada uma associada a uma pergunta, um questionário
# e uma submissão. Ela é responsável por armazenar e validar as respostas fornecidas pelos usuários.
#
class Answer < ApplicationRecord
  # Associação com a pergunta
  # @return [Question] A pergunta associada à resposta.
  belongs_to :question

  # Associação com o questionário
  # @return [Questionnaire] O questionário ao qual a resposta pertence.
  belongs_to :questionnaire

  # Associação com a submissão
  # @return [Submission] A submissão que contém a resposta.
  belongs_to :submission

  # Validações (opcionais, conforme necessidade)
  # Exemplo de validação:
  # validates :value, presence: true
  # validates :question_id, presence: true
end
