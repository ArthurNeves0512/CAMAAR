# app/models/question.rb
#
# Modelo que representa uma pergunta dentro de um questionário.
# Cada pergunta está associada a um template de questionário e pode ter várias respostas e opções de resposta.
# As perguntas podem ter diferentes tipos, como dissertativas ou de múltipla escolha.
#
# == Associações
#
# - +belongs_to :template+ - Indica que uma pergunta pertence a um template de questionário.
#   Cada pergunta é parte de um template específico, que organiza o questionário.
#
# - +has_many :answers+ - Indica que uma pergunta pode ter várias respostas associadas.
#   Cada resposta está vinculada a uma pergunta, representando as respostas dadas pelos usuários.
#
# - +has_many :question_options+ - Indica que uma pergunta pode ter várias opções de resposta associadas.
#   Esse relacionamento é relevante principalmente para perguntas de múltipla escolha, onde várias opções de resposta são fornecidas.
#
# == Validações
#
# - +validates :text, :question_type, presence: true+ - Garante que os campos 'text' e 'question_type' sejam preenchidos.
#
# == Exemplo de código:
# question = Question.new(text: "Qual a sua cor favorita?", question_type: "Múltipla escolha")
# question.save
#

class Question < ApplicationRecord
  # Relacionamento com o modelo Template
  belongs_to :template

  # Relacionamento com o modelo Answer
  has_many :answers, dependent: :destroy

  # Relacionamento com o modelo QuestionOption
  has_many :question_options, dependent: :destroy

  # Validações para garantir a presença de 'text' e 'question_type'
  validates :text, :question_type, presence: true
end
