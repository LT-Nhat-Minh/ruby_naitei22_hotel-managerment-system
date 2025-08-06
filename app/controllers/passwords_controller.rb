class PasswordsController < ApplicationController
  before_action :set_user, only: %i(edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)
  def edit; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t ".email_not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".blank")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by id: params[:user_id] || params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:user_id])

    flash[:danger] = t ".invalid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".expired"
    redirect_to new_password_reset_url
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
