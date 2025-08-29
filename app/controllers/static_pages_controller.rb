class StaticPagesController < ApplicationController
  before_action :set_current_user

  def home; end

  def help; end

  def contact; end

  private

  def set_current_user
    @current_user = current_user
  end
end
