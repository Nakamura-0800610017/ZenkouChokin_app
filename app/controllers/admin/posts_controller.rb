class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_root_path, success: t("default.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy!
    redirect_to admin_root_path, success: t("default.flash_message.deleted", item: Post.model_name.human), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:post_type, :body, :point)
  end
end
