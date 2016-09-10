class Chain < ActiveRecord::Base
  enum function: Command::FUNCTIONS
  belongs_to :actuator
  validates :hashtag, presence: true
end
