module BookingsHelper
  def booking_total_price(booking)
    booking.rooms.sum(:price)
  end
end
