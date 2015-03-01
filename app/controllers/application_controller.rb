class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protect_from_forgery

  before_action :get_host
  before_action :dev_tools if Rails.env == 'development'
  before_action :nav_cart

  # enable squash
  #include Squash::Ruby::ControllerMethods
  #enable_squash_client

  include ::Extension::GuestUser
  include ::Extension::Locale
  include ::Extension::Cancan
  include ::Extension::Exception
  include ::Extension::RecordCookie
  include ::Extension::SignInRedirect
  #include ::Extension::CookieCart
  include ::Extension::BulkExportAuthorization
  include ::Extension::MenuNavigator

  #before_action :load_cart

  # mobile request detection
  include Mobylette::RespondToMobileRequests

  def dev_tools
    Rack::MiniProfiler.authorize_request if defined?(Rack::MiniProfiler)
  end

  def nav_cart
    @nav_cart = Cart.find_by user_id: current_or_guest_user.id
    @nav_cart.destroy if @nav_cart && @nav_cart.expired?
  end

  def get_host
    $host = request.host_with_port
  end

  protected

  def devise_layout
    if Devise::RegistrationsController === self && ["edit", "update"].include?(action_name)
      is_mobile_request? ? 'mobile' : 'application'
    elsif Devise::InvitationsController === self
      is_mobile_request? ? 'mobile' : 'application'
    else
      is_mobile_request? ? 'mobile' : 'devise'
    end
  end

  def layout_by_resource
    if devise_controller? 
      devise_layout
    elsif params[:controller] == "postcards"
      is_mobile_request? ? 'postcard_mobile' : 'application'
    elsif params[:controller] == "orders"
      is_mobile_request? ? 'mobile' : 'order'
    else
      is_mobile_request? ? 'mobile' : 'application'
    end
  end

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super # Administrator will use the default one
    end
  end

  def justify_wechat_agent
    return if request.env["HTTP_USER_AGENT"].nil?
    if request.env["HTTP_USER_AGENT"].include? "MicroMessenger"
      @use_wechat_agent = true
    else
      @use_wechat_agent = false
    end
  end

  def signin_with_openid
    if @use_wechat_agent
      code = params[:code]
      state = params[:state]
      # params: target, redirect_url
      return if code.nil?
      request_url = Wechat::WechatHelper.wechat_oauth_url(:access_token, new_order_url, code)
      wechat_response = RestClient.get request_url
      wechat_responses = JSON.parse wechat_response
      if !wechat_responses["errmsg"]
        access_token = wechat_responses["access_token"]
        expires_in = wechat_responses["expires_in"]
        refresh_token = wechat_responses["refresh_token"]
        openid = wechat_responses["openid"]
        #sign in user
        user = User.find_by_openid(openid)
        sign_in user
      else
        raise ArgumentError, wechat_responses["errmsg"]
      end
    end
  end
end

class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params
      .permit(:email, :password, :password_confirmation,
              { phone: [] }, :name,
              :humanizer_answer, :humanizer_question_id)
  end

  def sign_in
    default_params.permit(:email, :password, :remember_me)
  end

  def account_update
    default_params
      .permit(:email, :password, :password_confirmation,
              :current_password, { phone: [] }, :name)
  end
end
