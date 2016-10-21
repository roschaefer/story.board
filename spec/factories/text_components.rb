FactoryGirl.define do
  factory :text_component do
    heading "MyString"
    introduction "MyText"
    main_part "MyText"
    closing "MyText"
    from_day nil
    to_day  nil

    association :report

    trait :active do
      # active by default
    end
  end
end
