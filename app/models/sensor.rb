class Sensor < ActiveRecord::Base
  has_many :sensor_readings, class_name: Sensor::Reading, dependent: :destroy
  belongs_to :sensor_type
  belongs_to :report
  has_many :conditions
  has_many :text_components, through: :conditions

  validates :report, presence: true
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
  validates :sensor_type, presence: true

  def active_text_components(source = :real)
    reading = sensor_readings.where(source: Sensor::Reading.sources[source]).last
    return [] if reading.nil?
    value = reading.calibrated_value
    holding_conditions = conditions.select { |c| c.from <= value && value <= c.to }
    holding_conditions.collect(&:text_component)
  end

  def address=(value)
    if value.respond_to?(:start_with?) && value.start_with?("0x") # probably a hex code string
      super(value.hex)
    else
      super(value)
    end
  end

  def last_value(source = :real)
    sensor_readings.send(source).last.try(&:calibrated_value)
  end

end
