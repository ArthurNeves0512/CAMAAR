class Questionnaire < ApplicationRecord
    belongs_to :template
    has_many :submissions, dependent: :destroy
    has_many :answers, dependent: :destroy
  
    validates :name, presence: true
end
