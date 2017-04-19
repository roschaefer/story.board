FactoryGirl.define do
  factory :channel do
    name 'JustAnotherChannel'
    association :report
  end
end
