class Question < ApplicationRecord
  belongs_to :template
  has_many :answers, dependent: :destroy
  has_many :question_options, dependent: :destroy

  validates :text, :question_type, presence: true
end
