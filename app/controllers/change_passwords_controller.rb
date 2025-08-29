class ChangePasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # GET (/:locale)/users/:user_id/password/edit(.:format)
  def edit
    @current_user = current_user
  end

  # PUT (/:locale)/users/:user_id/password(.:format)
  def update
    if @user.update(change_password_params)
      bypass_sign_in(@user)
      flash[:success] = t(".success")
      redirect_to edit_user_change_password_path(@user)
    else
      flash.now[:danger] = t(".wrong_password")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
