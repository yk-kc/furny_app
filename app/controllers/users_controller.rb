class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts # アソシエーションを持っているモデル同士の記述方法。@userに関連付けられた投稿全て（.posts）を取得し@postsに渡す処理
  end

  def edit
    @user = User.find(params[:id])
  end

end
