class BookmarksController < ApplicationController
  skip_before_action :require_login
  before_action :set_session_id

  def create
    @post = Post.find(params[:post_id])

    if current_user
      Bookmark.find_or_create_by!(user: current_user, post: @post)
    else
      Bookmark.find_or_create_by!(session_id: session[:bookmark_session_id], post: @post)
    end
  end

  def destroy
    @bookmark =
      if current_user
        Bookmark.find_by(user: current_user, id: params[:id])
      else
        Bookmark.find_by(session_id: session[:bookmark_session_id], id: params[:id])
      end

    @post = @bookmark.post
    @bookmark.destroy
  end

  private

  def set_session_id
    session[:bookmark_session_id] ||= SecureRandom.uuid
  end
end
