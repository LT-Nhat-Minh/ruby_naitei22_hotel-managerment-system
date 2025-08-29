FactoryBot.define do
  factory :booking do
    association :user
    sequence(:booking_code) { |n| "BK#{1000 + n}" }
    booking_date { Date.current }
    status { "draft" }
    status_changed_by_id { nil }
    decline_reason { nil }

    trait :confirmed do
      status { "confirmed" }
    end

    trait :declined do
      status { "declined" }
      decline_reason { "Not available" }
    end
  end
end
