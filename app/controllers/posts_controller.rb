class PostsController < ApplicationController
  skip_before_action :require_login, only: [ :index ]
  def index
    @posts = Post.where(post_type: :zenkou).order(created_at: :desc).includes(user: :user_point)
  end

def new_zenkou
  @post = Post.new(post_type: :zenkou)
  render :new
end

def new_akugyou
  @post = Post.new(post_type: :akugyou)
  render :new
end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, success: t("default.flash_message.created", item: Post.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to root_path, success: t("default.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to root_path, success: t("default.flash_message.deleted", item: Post.model_name.human), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:post_type, :body, :point)
  end
end
