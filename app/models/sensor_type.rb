class SensorType < ActiveRecord::Base
  default_scope { order(:property) }
  validates :unit, length: {minimum:  0, allow_nil: false}
  validates :fractionDigits, presence: true
  enum data_collection_method: {automatic: 0, manual: 1}
end
