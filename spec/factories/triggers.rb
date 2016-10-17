FactoryGirl.define do
  factory :trigger do
    heading "It's a heading"
    main_part 'And of course we have a main part'
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
