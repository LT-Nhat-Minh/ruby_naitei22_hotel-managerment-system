class BookingsController < ApplicationController
  before_action :set_user

  def index
    @bookings = @user.bookings
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
