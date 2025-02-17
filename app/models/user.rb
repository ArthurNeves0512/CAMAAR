# app/models/user.rb
#
# Modelo que representa um usuário no sistema. A classe User é responsável pela autenticação
# e pelos relacionamentos com outras entidades, como departamentos, salas de aula, submissões e matrículas.
#
# == Módulos do Devise
#
# - +:database_authenticatable+ - Habilita a autenticação via banco de dados com email e senha.
# - +:registerable+ - Permite o registro de novos usuários.
# - +:recoverable+ - Habilita a recuperação de senha.
# - +:rememberable+ - Permite manter a sessão ativa com a funcionalidade "lembrar-me".
# - +:validatable+ - Realiza a validação de formato de email e senha.
#
# == Associações
#
# - +belongs_to :department+ - Indica que um usuário pode pertencer a um departamento. A associação é opcional.
# - +has_many :classrooms+ - Um usuário pode estar associado a muitas salas de aula.
# - +has_many :submissions+ - Um usuário pode ter muitas submissões de questionários.
# - +has_many :enrollments+ - Um usuário pode estar matriculado em várias turmas.
# - +has_many :classrooms, through: :enrollments+ - Um usuário pode acessar as salas de aula através das suas inscrições.
# - +has_one :coordinator+ - Um usuário pode ter um coordenador associado.
#
# == Validações
#
# - +matricula+ deve ser obrigatória, única e ter no máximo 45 caracteres.
# - +nome+ deve ser obrigatório e ter no máximo 100 caracteres.
#
# == Método de autenticação personalizado
#
# O método +find_for_database_authentication+ permite autenticar um usuário por email ou matrícula.
# O método busca no banco de dados usuários que tenham o email ou matrícula correspondentes.
#
# == Exemplo de código:
# user = User.find_for_database_authentication(email: 'user@example.com')
# user.authenticate('password')
#

class User < ApplicationRecord
  # Módulos do Devise para autenticação
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Relacionamentos com outras entidades
  belongs_to :department, optional: true
  has_many :classrooms
  has_many :submissions
  has_many :enrollments
  has_many :classrooms, through: :enrollments
  has_one :coordinator

  # Validação dos atributos
  validates :matricula,
    presence: { message: " é obrigatória" },
    uniqueness: { message: " já está em uso" },
    length: { maximum: 45 }

  validates :nome,
    presence: { message: " é obrigatório" },
    length: { maximum: 100 }

  # Método de autenticação personalizada
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:email).downcase

    # Busca por email OU matrícula (tratamento insensível a maiúsculas/minúsculas)
    where(conditions).where(
      ["lower(email) = :value OR lower(matricula) = :value", { value: login } ]
    ).first
  end
end
