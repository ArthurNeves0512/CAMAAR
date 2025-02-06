class Subject < ApplicationRecord
  belongs_to :department
  has_many :classrooms, dependent: :destroy

  validates :name, :code, :time, presence: true
end
