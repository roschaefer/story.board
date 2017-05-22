FactoryGirl.define do
  factory :text_component do
    heading "MyString"
    introduction "MyText"
    main_part "MyText"
    closing "MyText"
    from_day nil
    to_day  nil

    association :report

    channels { [Channel.sensorstory] }

    publication_status 2

    trait :active do
      # active by default
    end

    factory :important_text_component do
      after(:create) do |text_component|
        create(:trigger, priority: :high, text_components: [text_component])
      end
    end

  end
end
