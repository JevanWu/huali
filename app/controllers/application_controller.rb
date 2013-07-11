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
    Rack::MiniProfiler.authorize_request
  end

  def get_host
    $host = request.host_with_port
  end

end
