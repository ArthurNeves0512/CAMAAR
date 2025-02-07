class Department < ApplicationRecord
  has_many :subjects, dependent: :destroy
  has_many :coordinators, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :name, presence: true
end
