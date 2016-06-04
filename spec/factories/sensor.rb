FactoryGirl.define do
  factory :sensor do
    name 'SENSORXY'
    sequence :address do |n|
      n
    end
    association :sensor_type
    association :report
  end
end
