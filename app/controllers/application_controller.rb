class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protect_from_forgery

  before_action :get_host
  before_action :dev_tools if Rails.env == 'development'

  # enable squash
  include Squash::Ruby::ControllerMethods
  enable_squash_client

  include ::Extension::GuestUser
  include ::Extension::Locale
  include ::Extension::Cancan
  include ::Extension::Exception
  include ::Extension::RecordCookie
  include ::Extension::SignInRedirect
  include ::Extension::CookieCart
  include ::Extension::BulkExportAuthorization

  before_action :load_cart

  # mobile request detection
  include Mobylette::RespondToMobileRequests

  def dev_tools
    Rack::MiniProfiler.authorize_request if defined?(Rack::MiniProfiler)
  end

  def get_host
    $host = request.host_with_port
  end

  protected

  def devise_layout
    if Devise::RegistrationsController === self && ["edit", "update"].include?(action_name)
      is_mobile_request? ? 'mobile' : 'application'
    else
      is_mobile_request? ? 'devise_mobile' : 'devise'
    end
  end

  def layout_by_resource
    if devise_controller?
      devise_layout
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
