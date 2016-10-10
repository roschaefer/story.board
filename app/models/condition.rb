class Condition < ActiveRecord::Base
  belongs_to :trigger
  belongs_to :sensor

  delegate :last_reading, to: :sensor
end
