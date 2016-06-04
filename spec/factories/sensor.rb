FactoryGirl.define do
  factory :sensor do
    name 'SENSORXY'
    address 4711
    association :sensor_type
    association :report
  end
end
