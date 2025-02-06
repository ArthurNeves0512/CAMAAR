class Subject < ApplicationRecord
  belongs_to :department
  belongs_to :user
  has_many :classrooms, dependent: :destroy
  has_many :users

  validates :name, :code, presence: true
  validates_uniqueness_of :code
end
