FactoryBot.define do
  factory :room do
    sequence(:room_number) { |n| "R#{100 + n}" }
    association :room_type
    description { "Default room description" }
    capacity { 2 }
    price_from_date { Date.today }
    price_to_date { Date.today + 30 }
    price { 150 }
  end
end
