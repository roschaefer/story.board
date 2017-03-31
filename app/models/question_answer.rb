class QuestionAnswer < ApplicationRecord
  belongs_to :text_component

  validates :question, length: { maximum: 640 }
  validates :answer, length: { maximum: 640 }
end
