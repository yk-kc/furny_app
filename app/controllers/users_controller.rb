class UsersController < ApplicationController
  before_action :user_admin, only: [:index]
  before_action :ensure_guest_user, only: [:edit]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).order(created_at: :desc) # アソシエーションを持っているモデル同士の記述方法。@userに関連付けられた投稿全て（.posts）を取得し@postsに渡す処理
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を編集しました。"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def withdraw
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to '/'
  end

  private

  def user_admin
    @users = User.all
    if  current_user.admin == false
       redirect_to "/"
    else
       render action: "index"
    end
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == 'guestuser@example.com'
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  # URLに含まれるユーザーidとログインしているユーザーのidが一致していなかった場合、 投稿一覧にリダイレクトする
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end

end
