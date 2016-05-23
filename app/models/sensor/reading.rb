class Sensor
  class Reading < ActiveRecord::Base
    belongs_to :sensor
    validates :sensor, :presence => true
  end
end

