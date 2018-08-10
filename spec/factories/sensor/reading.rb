FactoryBot.define do
  factory :sensor_reading, class: Sensor::Reading do
    calibrated_value 1
    uncalibrated_value 3
    association :sensor
  end
end
