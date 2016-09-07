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

  def name_and_id
    "#{name} (#{id})"
  end

  def address=(value)
    if value.respond_to?(:start_with?) && value.start_with?("0x") # probably a hex code string
      super(value.hex)
    else
      super(value)
    end
  end

  def last_reading(intention = :real)
    sensor_readings.send(intention).last
  end

end
