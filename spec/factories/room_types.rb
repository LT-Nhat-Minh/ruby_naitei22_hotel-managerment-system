FactoryBot.define do
  factory :room_type do
    name { "Single" }
    description { "Basic room" }
    price { 100 }

    trait :double do
      name { "Double" }
      description { "Double bed" }
      price { 200 }
    end

    trait :suite do
      name { "Suite" }
      description { "Luxury suite" }
      price { 300 }
    end
  end
end
