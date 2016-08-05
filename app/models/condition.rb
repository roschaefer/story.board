class Condition < ActiveRecord::Base
  belongs_to :text_component
  belongs_to :sensor

  delegate :last_reading, to: :sensor
end
