class Classroom < ApplicationRecord
  belongs_to :subject
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  validates :code, :semester, :time, presence: true

  validates :code, uniqueness: { scope: :subject_id }
end
