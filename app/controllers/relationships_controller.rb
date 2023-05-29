class RelationshipsController < ApplicationController

  # フォローするとき
  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    @user.create_notification_follow!(current_user)
  end
  # フォロー外すとき
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
  end
  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings.page(params[:page]).per(12)
  end
  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers.page(params[:page]).per(12)
  end

end
