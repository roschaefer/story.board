FactoryGirl.define do
  factory :trigger do
    name "It's a name"
    association :report


    trait :active do
      # is active by default
    end

    trait :inactive do
      after(:create) do |trigger|
        condition = create(:condition, trigger: trigger, from: 0, to: 5)
        create(:sensor_reading, sensor: condition.sensor, calibrated_value: 6)
      end
    end
  end
end
