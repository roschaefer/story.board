class Condition < ActiveRecord::Base
  belongs_to :text_component
  belongs_to :sensor

  delegate :last_value, to: :sensor
end
