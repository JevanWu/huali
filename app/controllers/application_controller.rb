class ApplicationController < ActionController::Base
  before_filter :set_locale, :get_host
  before_filter :dev_tools if Rails.env == 'development'

  after_filter :store_location

  protect_from_forgery

  include ::Extension::Mobile
  include ::Extension::GuestUser

  # rescue cancan authorization failure
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end

  unless Rails.application.config.consider_all_requests_local

    rescue_from 'Exception' do |exception|
      render_error 500, exception
    end

    rescue_from 'ActionController::RoutingError', 'ActionController::UnknownController', '::AbstractController::ActionNotFound', 'ActiveRecord::RecordNotFound' do |exception|
      render_error 404, exception
    end

  end


  # cancan's ability
  def current_ability
    @current_ability ||= Ability.new(current_administrator)
  end

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    case resource
    when User
      migrate_from_guest
      session[:previous_url] || root_path
    when Administrator
      admin_root_path
    end
  end

  # i18n helpers
  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    unless parsed_locale.nil?
      I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
    else
      nil
    end
  end

  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def dev_tools
    Rack::MiniProfiler.authorize_request
  end

  def get_host
    $host ||= request.host_with_port
  end
end
