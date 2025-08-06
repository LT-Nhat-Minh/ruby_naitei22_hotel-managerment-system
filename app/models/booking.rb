class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :status_changed_by, class_name: User.name, optional: true
  has_many :requests, dependent: :destroy
  has_many :room_availability_requests, through: :requests
  has_many :room_availabilities, through: :room_availability_requests
  has_many :rooms, through: :room_availabilities
  has_many :room_types, through: :rooms

  enum status: {
    draft: 0,
    pending: 1,
    confirmed: 2,
    declined: 3,
    cancelled: 4,
    completed: 5
  }, _prefix: true

  def booking_total_price
    rooms.sum(:price)
  end
end
