class User < ApplicationRecord

    has_secure_password

    has_many :enrollments, dependent: :destroy
    has_many :classrooms, through: :enrollments
    has_many :coordinators, dependent: :destroy
    has_many :submissions, dependent: :destroy
    validates :email, presence: true, uniqueness: true
end