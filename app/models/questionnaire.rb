# app/models/questionnaire.rb
class Questionnaire < ApplicationRecord
  belongs_to :template
  has_many :answers, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :questions, through: :template
end
