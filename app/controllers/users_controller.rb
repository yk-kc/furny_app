class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts # アソシエーションを持っているモデル同士の記述方法。@userに関連付けられた投稿全て（.posts）を取得し@postsに渡す処理
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

end
