class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    # ユーザーがいいねした投稿
    @posts = Post.joins(:favorites).where(favorites: { user_id: params[:user_id] })
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    @post.create_notification_like!(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

end
