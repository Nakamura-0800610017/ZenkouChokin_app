class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, success: t("default.flash_message.created", item: User.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_created", item: User.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    @user_point = @user.user_point
    @total_points = @user_point.total_points.round
    @zenkou = @user.posts.zenkou.order(created_at: :desc)
    @akugyou = @user.posts.akugyou.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), success: t("default.flash_message.updated", item: User.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = current_user
    user.destroy!
    logout
    redirect_to root_path, success: t("default.flash_message.deleted", item: User.model_name.human), status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :terms_of_service)
  end
end
