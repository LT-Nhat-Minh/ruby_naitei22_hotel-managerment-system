FactoryBot.define do
  factory :booking do
    association :user
    sequence(:booking_code) { |n| "BK#{1000 + n}" }
    booking_date { Time.zone.now }
    status { 0 } # draft/pending tùy enum
  end
end
