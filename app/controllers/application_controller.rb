class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :get_host
  before_action :dev_tools if Rails.env == 'development'

  # enable squash
  include Squash::Ruby::ControllerMethods
  enable_squash_client

  include ::Extension::Mobile
  include ::Extension::GuestUser
  include ::Extension::Locale
  include ::Extension::Cancan
  include ::Extension::Exception
  include ::Extension::RecordCookie
  include ::Extension::SignInRedirect

  def dev_tools
    Rack::MiniProfiler.authorize_request if defined?(Rack::MiniProfiler)
  end

  def get_host
    $host = request.host_with_port
  end

  protected

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
              :phone, :name, :humanizer_answer, :humanizer_question_id)
  end

  def sign_in
    default_params.permit(:email, :password, :remember_me)
  end

  def account_update
    default_params
      .permit(:email, :password, :password_confirmation, :current_password)
      .permit(:phone, :name)
  end
end
