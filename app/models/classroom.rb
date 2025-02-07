class Classroom < ApplicationRecord
  belongs_to :subject
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  # refactored to use association name 'teacher' for clarity
  belongs_to :teacher, -> { where(role: 1) }, class_name: "User"

  validates :code, :semester, :time, presence: true

  validates :code, uniqueness: { scope: :subject_id }
end
