FactoryBot.define do
  factory :request do
    association :booking
    association :room
    check_in { Date.today.to_datetime.change(hour: 11) }
    check_out { (Date.today + 1).to_datetime.change(hour: 16) }
    number_of_guests { 2 }
    status { 0 } # pending
    note { "Default request note" }
  end
end
