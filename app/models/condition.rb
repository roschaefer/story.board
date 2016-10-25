class Condition < ActiveRecord::Base
  belongs_to :trigger
  belongs_to :sensor

  validates :sensor, presence: true
  validates :trigger, presence: true

  delegate :last_reading, to: :sensor
end
