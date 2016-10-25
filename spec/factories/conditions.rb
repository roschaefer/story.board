FactoryGirl.define do
  factory :condition do
    from 1
    to 1
    association :sensor
    association :trigger
  end
end
