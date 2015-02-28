class UsersController < ApplicationController
  before_action :justify_wechat_agent, only: [:profile]
  before_action :signin_with_openid, only: [:profile]
  before_action :authenticate_user!,
    except: [:check_user_exist, :subscribe_email, :omnicontacts_callback, :omnicontacts_failure, :profile]
  respond_to :json, :html

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

  def setting
    @user = current_user
    @partial = "setting"

    respond_to do |format|
      format.html
      format.js { render "update_partial", layout: false }
    end
  end

  def orders
    @user = current_user
    @orders = current_or_guest_user.orders
    @partial = "orders"

    respond_to do |format|
      format.html
      format.js { render "update_partial", layout: false }
    end
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

  def huali_point
    @point_transactions = current_user.point_transactions.order(:created_at).page(params[:page]).per(3)
    @partial = "huali_point"

    respond_to do |format|
      format.html
      format.js { render "update_partial", layout: false }
    end
  end

  def refer_friend
    @user = User.new
    @partial = "refer_friend"

    respond_to do |format|
      format.html
      format.js { render "update_partial", layout: false }
    end
  end

  def email_mimic_signin
    if params[:provider]
      @provider = params[:provider]
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def import_email_contacts
    @username = params[:email]
    @password = params[:passwd]
    if params[:email_provider] == "163"
      importer = ContactsImporter::Netease163.new(@username, @password)
    elsif params[:email_provider] == "126"
      importer = ContactsImporter::Netease126.new(@username, @password)
    end

    if importer.success_login?
      @contacts = importer.get_contacts
    else
      flash[:alert] = t("login_failed")
      redirect_to email_signin_path and return
    end
    @user = User.new
    render :refer_friend
  end

  def check_user_exist
    if u = User.find_by_email(check_user_params)
      result = { found: true, email: u.email }
    else
      result = { found: false }
    end

    render json: result
  end

  def subscribe_email
    if params[:email] =~ /\A[^@]+@[^@]+\z/
      Utils.delay.subscribe_to_mailchimp(params[:email])
      redirect_to root_path, notice: "订阅成功"
    else
      redirect_to root_path, notice: "无效的 Email, 订阅失败"
    end
  end

  def omnicontacts_callback
    retrieved_contacts = request.env['omnicontacts.contacts']
    unless retrieved_contacts.nil?
      @contacts = Array.new
      retrieved_contacts.each do |c|
        next if c[:email].nil?
        contact = OpenStruct.new
        name = c[:name].nil? ? c[:email] : c[:name]
        contact.name = name
        contact.email = c[:email]
        @contacts << contact
      end
    end
    @user = User.new
    render :refer_friend
    # @user = request.env['omnicontacts.user']
  end

  def omnicontacts_failure
    @error_message = t("controllers.user.omnicontacts.#{params[:error_message]}")
  end

  def profile
    if current_user.nil? && params[:code].nil?
      redirect_to Wechat::WechatHelper.wechat_oauth_url(:code, profile_url)
    end
    @user = current_user
  end

  def new_binding_account
    redirect_to profile_path(current_user), flash: {success: "您已经绑定过账号了"} if !current_user.email.nil?
  end

  def binding_account
    user = User.find_by email: params[:user][:email]
    password = params[:user][:password]
    anon_user = current_user
    if user.valid_password?(password)
      %w(addresses orders oauth_providers oauth_services tracking_cookie point_transactions coupon_codes).each do |vars|
        anon_user.send(vars).each{ |var| var.update_column(:user_id, user.id) } unless current_user.send(vars).nil? 
      end
      user.update_column(:huali_point, user.huali_point + anon_user.huali_point)
      sign_in user
      anon_user.delete
      redirect_to profile_path(user), flash: {success: "绑定成功"}
    else
      redirect_to users_new_binding_account_path, flash: {error: "账户密码不匹配"}
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
