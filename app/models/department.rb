class Department < ApplicationRecord
    has_many :subjects, dependent: :destroy
    has_many :coordinators, dependent: :destroy
  
    validates :name, presence: true
end