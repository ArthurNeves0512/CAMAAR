# app/models/enrollment.rb
#
# Modelo que representa uma matrícula de um usuário em uma turma.
# Cada matrícula está associada a um usuário e a uma turma específica.
#
# == Associações
#
# - +belongs_to :user+ - Indica que a matrícula pertence a um usuário (usuário que se matriculou na turma).
#   Um usuário pode estar matriculado em várias turmas.
# - +belongs_to :classroom+ - Indica que a matrícula pertence a uma turma específica.
#   Cada matrícula está associada a uma única turma.
#
# == Exemplo de código:
# enrollment = Enrollment.new(user: some_user, classroom: some_classroom)
# enrollment.save
#

class Enrollment < ApplicationRecord
  # Relacionamento com o modelo User
  # Indica que uma matrícula pertence a um usuário.
  # Um usuário pode estar matriculado em várias turmas.
  belongs_to :user

  # Relacionamento com o modelo Classroom
  # Indica que uma matrícula pertence a uma turma (classroom).
  # Cada matrícula está associada a uma única turma.
  belongs_to :classroom
end
