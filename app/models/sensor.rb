class Sensor < ActiveRecord::Base
  has_many :sensor_readings, :class_name => Sensor::Reading, :dependent => :destroy
  belongs_to :sensor_type
  belongs_to :report
  has_many :conditions
  has_many :text_components, :through => :conditions

  validates :report, :presence => true
  validates :name, :presence => true, :uniqueness => true
  validates :sensor_type, :presence => true


  def active_text_components
    reading = self.sensor_readings.last
    return [] if reading.nil?
    value = reading.calibrated_value
    holding_conditions = self.conditions.select {|c| c.from <= value && value <= c.to }
    holding_conditions.collect {|c| c.text_component }
  end
end
