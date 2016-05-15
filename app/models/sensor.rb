class Sensor < ActiveRecord::Base
  validates :name, :presence => true
  has_many :sensor_readings, :dependent => :destroy
end
