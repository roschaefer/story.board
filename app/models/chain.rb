class Chain < ActiveRecord::Base
  enum function: Command::FUNCTIONS
  belongs_to :actuator
  validates :hashtag, presence: true, uniqueness: true

  delegate :name, to: :actuator, prefix: true, allow_nil: true
end
