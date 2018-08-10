FactoryBot.define do
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

  trait :with_a_reading do
    after(:create) do |sensor|
      create(:sensor_reading, sensor: sensor)
    end
  end
end
