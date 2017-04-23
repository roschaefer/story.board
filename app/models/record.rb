class Record < ActiveRecord::Base
  attr_accessor :question_answers

  enum intention: [:real, :fake]
  LIMIT = 10
  belongs_to :report

  def live?
    created_at.nil?
  end
end
