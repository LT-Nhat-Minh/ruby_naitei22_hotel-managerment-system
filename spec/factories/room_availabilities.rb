FactoryBot.define do
  factory :room_availability do
    association :room
    available_date { Date.today }
    price { 200 }
    is_available { true }
  end
end
