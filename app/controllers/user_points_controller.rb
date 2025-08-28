class UserPointsController < ApplicationController
  before_action :block_focus_mode, only: [ :index ]

  def index
    @user_points = UserPoint.includes(:user).order(total_points: :desc).limit(10)
  end
end
