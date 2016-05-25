class Condition < ActiveRecord::Base
  belongs_to :text_component
  belongs_to :sensor
end
