class FavoritesController < ApplicationController
  before_action :is_matching_login_user, only: [:index]

  def index
    # ユーザーがいいねした投稿
    @posts = Post.joins(:favorites).where(favorites: { user_id: params[:user_id] })
    @user = User.find(params[:user_id])
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

  private

   # URLに含まれるユーザーidとログインしているユーザーのidが一致していなかった場合、 投稿一覧にリダイレクトする
  def is_matching_login_user
    user = User.find(params[:user_id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end

end
