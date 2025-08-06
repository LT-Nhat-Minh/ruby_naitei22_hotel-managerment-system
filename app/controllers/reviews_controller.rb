class ReviewsController < ApplicationController
  before_action :set_user

  def index
    @reviews = @user.reviews
  end

  def destroy
    @review = @user.reviews.find_by(id: params[:id])
    if @review&.destroy
      flash[:success] = t(".success")
    else
      flash[:error] = t(".error")
    end
    redirect_to user_reviews_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
