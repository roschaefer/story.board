class SensorType < ActiveRecord::Base
  default_scope { order(:property) }
  validates :unit, length: { minimum:  0, allow_nil: false }
  validates :fractionDigits, presence: true
end
