# == User Model
#
# O modelo `User` é responsável por gerenciar as informações e autenticação dos usuários no sistema.
# Ele inclui funcionalidades do Devise para autenticação e controle de senhas, além de validar e gerenciar os papéis dos usuários e suas associações com outras entidades no sistema.
#
# == Associações
# 
# * `belongs_to :department` - O usuário pode pertencer a um departamento. Esse relacionamento é opcional.
# * `has_many :classrooms` - O usuário pode ter várias salas de aula.
# * `has_many :submissions` - O usuário pode ter várias submissões (presumivelmente de avaliações).
# * `has_many :enrollments` - O usuário pode ter várias matrículas em turmas.
# * `has_many :classrooms, through: :enrollments` - O usuário pode acessar as turmas por meio de matrículas.
# * `has_one :coordinator` - O usuário pode ter um coordenador associado, no caso de ser um professor ou similar.
#
# == Validações
#
# * `validates :matricula` - A matrícula do usuário é obrigatória e deve ser única. Seu comprimento máximo é de 45 caracteres.
# * `validates :nome` - O nome do usuário é obrigatório e seu comprimento máximo é de 100 caracteres.
#
# == Enumeração de Papel (role)
#
# * O atributo `role` usa uma enumeração com três papéis possíveis:
#   - `student` (0): Usuário do tipo estudante.
#   - `teacher` (1): Usuário do tipo professor.
#   - `admin` (2): Usuário do tipo administrador.
# * O valor padrão é `student`.
#
# == Métodos
#
# === `find_for_database_authentication`
# 
# Método responsável por autenticar um usuário com base no email ou matrícula. Este método é utilizado pelo Devise para permitir o login.
#
# @param [Hash] warden_conditions Condições de autenticação, geralmente incluindo o email ou matrícula do usuário.
# @return [User, nil] Retorna o usuário correspondente ou `nil` se não encontrado.
#
class User < ApplicationRecord
  # Adiciona os módulos do Devise para autenticação
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Associações
  belongs_to :department, optional: true
  has_many :classrooms
  has_many :submissions
  has_many :enrollments
  has_many :classrooms, through: :enrollments
  has_one :coordinator

  # Enumeração de papel (role)
  enum :role, { student: 0, teacher: 1, admin: 2 }, default: :student

  # Validações
  validates :matricula,
    presence: { message: " é obrigatória" },
    uniqueness: { message: " já está em uso" },
    length: { maximum: 45 }

  validates :nome,
    presence: { message: " é obrigatório" },
    length: { maximum: 100 }

  # Método de autenticação personalizado, que permite o login com email ou matrícula.
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:email).downcase

    # Busca por email OU matrícula
    where(conditions).where(
      ["lower(email) = :value OR lower(matricula) = :value", { value: login }]
    ).first
  end
end
