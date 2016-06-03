class Sensor
  class Reading < ActiveRecord::Base
    belongs_to :sensor
    validates :sensor, :presence => true
    validates :calibrated_value, :presence => true
    validates :uncalibrated_value, :presence => true
  end
end

