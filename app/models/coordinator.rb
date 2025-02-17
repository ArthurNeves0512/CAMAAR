# app/models/coordinator.rb
#
# Modelo que representa o coordenador de um departamento.
# Cada coordenador está associado a um usuário e a um departamento.
# O coordenador é responsável por gerenciar e coordenar atividades dentro de seu departamento.
#
# == Associações
#
# - +belongs_to :user+ - Cada coordenador está associado a um único usuário.
#   O usuário representa o responsável administrativo ou acadêmico.
# - +belongs_to :department+ - Cada coordenador está vinculado a um único departamento.
#   O departamento representa a área de atuação do coordenador.
#
# == Exemplo de código:
# coordinator = Coordinator.new(user: some_user, department: some_department)
# coordinator.save
#

class Coordinator < ApplicationRecord
  # Relacionamento com o modelo User
  # Indica que um Coordenador pertence a um único Usuário.
  # Cada Coordenador está associado a um Usuário, representando o responsável administrativo ou acadêmico.
  belongs_to :user

  # Relacionamento com o modelo Department
  # Indica que um Coordenador pertence a um único Departamento.
  # Cada Coordenador está vinculado a um Departamento específico, representando sua área de atuação.
  belongs_to :department
end
