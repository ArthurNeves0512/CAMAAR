# app/models/template.rb
#
# Modelo que representa um template de questionário.
# Um template pode ter vários questionários e perguntas associados a ele.
#
# == Associações
#
# - +has_many :questionnaires+ - Indica que um template pode ter vários questionários associados a ele.
#   Quando um template é destruído, todos os questionários associados a ele também são destruídos.
#
# - +has_many :questions+ - Indica que um template pode ter várias perguntas associadas a ele.
#   Quando um template é destruído, todas as perguntas associadas também são destruídas.
#
# == Validações
#
# - +validates :name, presence: true+ - Garante que o campo 'name' seja fornecido ao criar ou atualizar um template.
#
# == Exemplo de código:
# template = Template.new(name: 'Template A')
# template.save
#

class Template < ApplicationRecord
  # Relacionamento com o modelo Questionnaire
  has_many :questionnaires, dependent: :destroy

  # Relacionamento com o modelo Question
  has_many :questions, dependent: :destroy

  # Validação de presença para o campo 'name'
  validates :name, presence: true
end
