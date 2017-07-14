class SensorType < ActiveRecord::Base
  default_scope { order(:property) }
end
