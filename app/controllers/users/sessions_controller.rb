class Users::SessionsController < Devise::SessionsController
  # ゲストログイン機能
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'guestuserでログインしました。'
  end

  protected

  # 会員の論理削除のための記述。退会後は、同じアカウントでは利用できない。
  def reject_user
    @user = User.find_by(email: params[:user][:email])
    return if !@user
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == true)
        flash[:alert] = "退会済みです。再度ご登録をしてご利用ください。"
        redirect_to new_user_registration_path
      else
        flash[:alert] = "項目を入力してください"
      end
  end
end