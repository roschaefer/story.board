FactoryGirl.define do
  factory :command do
    actuator nil
    value "MyString"
    executed false
  end
end
