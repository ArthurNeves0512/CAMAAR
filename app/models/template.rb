class Template < ApplicationRecord
    has_many :questionnaires, dependent: :destroy
    has_many :questions, dependent: :destroy
  
    validates :name, presence: true
end