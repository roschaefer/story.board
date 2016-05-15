class SensorReading < ActiveRecord::Base
  belongs_to :sensor
  validates :sensor, :presence => true
end
