FactoryGirl.define do
  factory :text_component do
    heading "MyString"
    introduction "MyText"
    main_part "MyText"
    closing "MyText"
    from_day nil
    to_day  nil

    association :report

    channels { create_list(:channel, 1) }

    trait :active do
      # active by default
    end
  end
end
