FactoryGirl.define do
  factory :text_component do
    heading "MyString"
    introduction "MyText"
    main_part "MyText"
    closing "MyText"
    from_day nil
    to_day  nil

    association :report

    channel_ids { [Channel.sensorstory.id] }

    publication_status :published

    trait :active do
      # active by default
    end

    factory :important_text_component do
      after(:create) do |text_component|
        create(:trigger, priority: :high, text_components: [text_component])
      end
    end

    trait :with_question_answers do
      after(:create) do |text_component, _|
        create_list(:question_answer, 2, text_component: text_component)
      end
    end
  end
end
