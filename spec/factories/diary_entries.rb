FactoryGirl.define do
  factory :diary_entry do
    heading "MyString"
    introduction "MyString"
    main_part "MyString"
    closing "MyString"

    association :report
  end
end
