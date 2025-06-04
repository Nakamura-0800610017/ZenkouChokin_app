class PostsController < ApplicationController
  skip_before_action :require_login, only: [ :index ]
  def index
    @posts = Post.all.order(created_at: :desc)
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

  def point_select
    @post = Post.new(post_params)
    render turbo_stream: turbo_stream.replace(
    "point_select",
    partial: "posts/point_select",
    locals: { post: @post }
  )
end

  private

  def post_params
    params.require(:post).permit(:post_type, :body, :point)
  end
end
