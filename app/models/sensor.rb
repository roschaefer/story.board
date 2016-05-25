class Sensor < ActiveRecord::Base
  has_many :sensor_readings, :class_name => Sensor::Reading, :dependent => :destroy
  belongs_to :sensor_type

  validates :name, :presence => true, :uniqueness => true
  validates :sensor_type, :presence => true
end
