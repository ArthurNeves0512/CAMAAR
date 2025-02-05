# app/models/user.rb
class User < ApplicationRecord
  # Adicione módulos do Devise (ex: :database_authenticatable, :registerable, etc.)
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Suas associações existentes
  has_many :submissions
  has_many :enrollments
  has_many :classrooms, through: :enrollments
  has_one :coordinator

  

  # Validação de papel (role)
  enum :role, { student: 0, teacher: 1, admin: 2 }, default: :student

  validates :matricula, 
    presence: { message: " é obrigatória" }, 
    uniqueness: { message: " já está em uso" }, 
    length: { maximum: 45 }

  validates :nome, 
    presence: { message: " é obrigatório" }, 
    length: { maximum: 100 }

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:email).downcase
    
      # Busca por email OU matrícula
      where(conditions).where(
        ["lower(email) = :value OR lower(matricula) = :value", { value: login }]
      ).first
    end
end