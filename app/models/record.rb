class Record < ActiveRecord::Base
  enum intention: [:real, :fake]
  LIMIT = 10
  belongs_to :report
end
