class UserPointsController < ApplicationController
  def index
    @user_points = UserPoint.includes(:user).order(total_points: :desc).limit(10)
  end
end
