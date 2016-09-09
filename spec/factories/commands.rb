FactoryGirl.define do
  factory :command do
    actor nil
    value "MyString"
    executed false
  end
end
