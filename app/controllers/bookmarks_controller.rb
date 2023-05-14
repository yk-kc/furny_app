class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    # ユーザーがブックマークした投稿
    @posts = Post.joins(:bookmarks).where(bookmarks: { user_id: params[:user_id] })
  end

  def create
    post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.new(post_id: post.id)
    bookmark.save
    redirect_to request.referer
  end

  def destroy
    post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.find_by(post_id: post.id)
    bookmark.destroy
    redirect_to request.referer
  end

end
