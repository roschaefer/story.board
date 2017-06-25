class DiaryEntry < ActiveRecord::Base
  enum intention: [:real, :fake]
  LIMIT = 10
  belongs_to :report

  def live?
    created_at.nil?
  end
end
