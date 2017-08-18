FactoryGirl.define do
  factory :event do
    sequence(:name) {|n| "Event #{n}" }
  end
end
