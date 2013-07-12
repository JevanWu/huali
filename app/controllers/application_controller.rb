class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :get_host
  before_action :dev_tools if Rails.env == 'development'
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user
        .permit(:email, :password, :password_confirmation, :remember_me)
        .permit(:phone, :name, :humanizer_answer, :humanizer_question_id)
        .permit(:role)
        # FIXME only required by administrator
    end

    devise_parameter_sanitizer.for(:sign_in) do |user|
      user.permit(:email, :password, :remember_me)
    end
  end
end
