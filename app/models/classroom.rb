# app/models/classroom.rb
#
# Modelo que representa uma turma (classe), associada a um assunto e aos usuários (estudantes e professores).
# Cada turma possui um código, semestre e horário, e pode ter múltiplos alunos (users) e um professor.
#
# == Associações
#
# - +belongs_to :subject+ - Cada turma está associada a um assunto ou disciplina.
# - +has_many :enrollments+ - Cada turma pode ter múltiplos alunos através de matrículas.
# - +has_many :users+ - Através da tabela intermediária de matrículas, uma turma pode ter múltiplos alunos.
# - +belongs_to :teacher+ - Cada turma tem um professor, e a associação filtra para incluir apenas usuários com o papel de professor.
#
# == Validações
#
# - +validates :code, :semester, :time, presence: true+ - Garante que o código, semestre e horário sejam fornecidos.
# - +validates :code, uniqueness: { scope: :subject_id }+ - Garante que o código da turma seja único para cada assunto.
#
# == Exemplo de código:
# classroom = Classroom.new(code: 'MAT101', semester: '2025', time: '10:00', subject: some_subject, teacher: some_teacher)
# classroom.save
#

class Classroom < ApplicationRecord
  # Associação com o modelo Subject, representando o assunto ou disciplina da turma.
  belongs_to :subject

  # Associações com o modelo User através da tabela intermediária Enrollment,
  # permitindo que a turma tenha múltiplos alunos (users).
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  # Associação com o modelo User, representando o professor da turma,
  # a associação é filtrada para incluir apenas usuários com o papel de professor (role: 1).
  belongs_to :teacher, -> { where(role: 1) }, class_name: "User"

  # Validação de presença para os campos 'code', 'semester' e 'time'.
  validates :code, :semester, :time, presence: true

  # Validação de unicidade do campo 'code', garantindo que cada código de turma seja único para um determinado assunto (subject).
  validates :code, uniqueness: { scope: :subject_id }
end
