FactoryBot.define do
  factory :room_type do
    sequence(:name) { |n| "Loại phòng #{n}" }
    description { "Mô tả loại phòng" }
    price { 100 }
  end
end