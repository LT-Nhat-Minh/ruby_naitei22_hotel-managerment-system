FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }

    trait :admin do
      role { :admin }
    end
  end
end
