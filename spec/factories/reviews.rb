FactoryBot.define do
  factory :review do
    association :user
    association :request
    rating { 4 }
    comment { "Good service" }
    review_status { "pending" }
  end
end
