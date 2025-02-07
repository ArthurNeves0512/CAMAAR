class Subject < ApplicationRecord
  belongs_to :department
  has_many :classrooms, dependent: :destroy

  validates :name, :code, presence: true
  validates_uniqueness_of :code
end
