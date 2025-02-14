class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :questionnaire
  has_many :answers
end
