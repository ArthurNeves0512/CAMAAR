# app/models/questionnaire.rb
#
# Modelo que representa um questionário, que está associado a um template de formulário.
# O questionário pode ter várias respostas, submissões e perguntas associadas.
# As perguntas de um questionário são herdadas do template associado.
#
# == Associações
#
# - +belongs_to :template+ - Indica que um questionário pertence a um template de formulário.
#   O questionário é baseado em um template específico que define sua estrutura e perguntas.
#
# - +has_many :answers+ - Indica que um questionário pode ter várias respostas associadas.
#   As respostas representam as informações fornecidas pelos usuários ao responderem ao questionário.
#
# - +has_many :submissions+ - Indica que um questionário pode ter várias submissões de usuários.
#   As submissões representam os envios de questionários preenchidos por diferentes usuários.
#
# - +has_many :questions, through: :template+ - Indica que um questionário possui muitas perguntas associadas,
#   que são herdadas do template. Esse relacionamento estabelece que as perguntas de um questionário
#   são determinadas pelo template relacionado.
#
# == Exemplo de código:
# questionnaire = Questionnaire.new(template: some_template)
# questionnaire.save
#

class Questionnaire < ApplicationRecord
  # Relacionamento com o modelo Template
  belongs_to :template

  # Relacionamento com o modelo Answer
  has_many :answers, dependent: :destroy

  # Relacionamento com o modelo Submission
  has_many :submissions, dependent: :destroy

  # Relacionamento com o modelo Question através de Template
  has_many :questions, through: :template
end
