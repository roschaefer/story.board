class Sensor < ActiveRecord::Base
  has_many :sensor_readings, :class_name => Sensor::Reading, :dependent => :destroy
  belongs_to :sensor_type
  has_many :conditions
  has_many :text_components, :through => :conditions

  validates :name, :presence => true, :uniqueness => true
  validates :sensor_type, :presence => true
end
