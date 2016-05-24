FactoryGirl.define do
  factory :sensor do
    name "SENSORXY"
    association :sensor_type
  end
end
