FactoryBot.define do
  factory :guest do
    association :request
    full_name { "Nguyen Van A" }
    identity_type { "national_id" }
    identity_number { "123456789012" }
    identity_issued_date { 2.years.ago.to_date }
    identity_issued_place { "Ha Noi" }
  end
end
