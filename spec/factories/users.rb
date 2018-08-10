FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    sequence :password do |n|
      "password-#{n}"
    end

    sequence :name do |n|
      "User-#{n}"
    end
  end
end
