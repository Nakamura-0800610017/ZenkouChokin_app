class PostsController < ApplicationController
  skip_before_action :require_login, only: [ :index ]
  def index
    @posts = Post.where(post_type: :zenkou).order(created_at: :desc)
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
      redirect_to root_path, success: "投稿しました"
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_type, :body, :point)
  end
end
