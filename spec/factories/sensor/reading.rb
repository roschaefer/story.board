FactoryGirl.define do
  factory :sensor_reading, :class => Sensor::Reading do
    association :sensor
  end
end
