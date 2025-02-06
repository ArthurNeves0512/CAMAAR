class Classroom < ApplicationRecord
  belongs_to :subject
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  validates :code, :semester, presence: true
end
