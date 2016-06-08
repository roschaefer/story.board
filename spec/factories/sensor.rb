FactoryGirl.define do
  factory :sensor do
    sequence :name do |n|
      "Sensor#{n}"
    end
    sequence :address do |n|
      n
    end
    association :sensor_type
    association :report
  end
end
