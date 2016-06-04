FactoryGirl.define do
  factory :text_component do
    heading "It's a heading"
    main_part 'And of course we have a main part'
    association :report
  end
end
