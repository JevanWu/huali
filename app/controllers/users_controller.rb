class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit_profile, :edit_account, :update_password, :update_profile]
  respond_to :json

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = User.find(current_user.id)

    if @user.update_attributes(profile_params)
      flash[:notice] = t("controllers.user.profile_updated")
      redirect_to action: :edit_profile
    else
      render :edit_profile
    end
  end

  def edit_account
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(password_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true

      flash[:notice] = t("controllers..user.password_updated")
      redirect_to action: 'edit_account'
    else
      render "edit_account"
    end
  end

  def check_user_exist
    if u = User.find_by_email(check_user_params)
      result = { found: true, email: u.email }
    else
      result = { found: false }
    end

    respond_with(result)
  end

  def subscribe_email
    if params[:email] =~ /\A[^@]+@[^@]+\z/
      Utils.delay.subscribe_to_mailchimp(params[:email])
      redirect_to root_path, notice: "订阅成功"
    else
      redirect_to root_path, notice: "无效的 Email, 订阅失败"
    end
  end

  private

  def check_user_params
    params.require(:user_email)
  end

  def profile_params
    params.required(:user).permit(:email, { phone: [] }, :name)
  end

  def password_params
    params.required(:user).permit(:current_password, :password, :password_confirmation)
  end
end
