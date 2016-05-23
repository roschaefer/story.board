class Sensor < ActiveRecord::Base
  validates :name, :presence => true
  has_many :sensor_readings, :class_name => Sensor::Reading, :dependent => :destroy
end
