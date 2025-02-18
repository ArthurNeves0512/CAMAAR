# app/models/question_option.rb
#
# Modelo que representa uma opção de resposta associada a uma pergunta em um questionário.
# Cada opção de pergunta está associada a uma única pergunta, mas uma pergunta pode ter várias opções.
#
# == Associações
#
# - +belongs_to :question+ - Indica que a opção de resposta pertence a uma pergunta.
#   Uma pergunta pode ter várias opções de resposta, mas cada opção de resposta pertence a uma única pergunta.
#
# == Exemplo de código:
# question_option = QuestionOption.new(question: some_question, option_text: "Opção 1")
# question_option.save
#

class QuestionOption < ApplicationRecord
  # Relacionamento com o modelo Question
  # Indica que uma opção de pergunta pertence a uma pergunta.
  # Uma pergunta pode ter várias opções de resposta, mas cada opção de pergunta pertence a uma única pergunta.
  belongs_to :question
end
