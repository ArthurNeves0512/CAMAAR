# app/models/questionnaire.rb
class Questionnaire < ApplicationRecord
    belongs_to :template
    has_many :submissions
    has_many :questions, through: :template
  end