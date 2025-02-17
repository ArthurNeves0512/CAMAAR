# app/models/department.rb
#
# Modelo que representa um departamento acadêmico.
# Cada departamento pode ter várias disciplinas (subjects), coordenadores (coordinators) e usuários (users).
# O departamento é responsável pela organização e gestão das disciplinas e coordenação de atividades acadêmicas.
#
# == Associações
#
# - +has_many :subjects+ - Cada departamento pode ter muitas disciplinas (subjects).
#   Quando um departamento é destruído, todas as disciplinas associadas também são destruídas devido à opção +dependent: :destroy+.
# - +has_many :coordinators+ - Cada departamento pode ter muitos coordenadores (coordinators).
#   Quando um departamento é destruído, todos os coordenadores associados também são destruídos devido à opção +dependent: :destroy+.
# - +has_many :users+ - Cada departamento pode ter muitos usuários (users).
#   Quando um departamento é destruído, todos os usuários associados também são destruídos devido à opção +dependent: :destroy+.
#
# == Validações
#
# - +validates :name, presence: true+ - Garante que o nome do departamento seja informado ao criar ou atualizar o departamento.
#
# == Exemplo de código:
# department = Department.new(name: 'Ciências da Computação')
# department.save
#

class Department < ApplicationRecord
  # Relacionamento com o modelo Subject
  # Indica que um Departamento pode ter muitos Subjects (disciplinas).
  # Quando um Departamento é destruído, todas as suas disciplinas também são destruídas devido ao dependent: :destroy.
  has_many :subjects, dependent: :destroy

  # Relacionamento com o modelo Coordinator
  # Indica que um Departamento pode ter muitos Coordinators (coordenadores).
  # Quando um Departamento é destruído, todos os seus coordenadores também são destruídos devido ao dependent: :destroy.
  has_many :coordinators, dependent: :destroy

  # Relacionamento com o modelo User
  # Indica que um Departamento pode ter muitos Users (usuários).
  # Quando um Departamento é destruído, todos os seus usuários também são destruídos devido ao dependent: :destroy.
  has_many :users, dependent: :destroy

  # Validação de presença para o nome do Departamento
  # Garante que o nome do departamento seja informado ao criar ou atualizar o Departamento.
  validates :name, presence: true
end
