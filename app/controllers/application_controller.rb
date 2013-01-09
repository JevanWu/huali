class ApplicationController < ActionController::Base
  before_filter :set_locale, :check_for_mobile, :get_host
  before_filter :dev_tools if Rails.env == 'development'

  after_filter :store_location

  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local

    rescue_from 'Exception' do |exception|
      render_error 500, exception
    end

    rescue_from 'ActionController::RoutingError', 'ActionController::UnknownController', '::AbstractController::ActionNotFound', 'ActiveRecord::RecordNotFound' do |exception|
      render_error 404, exception
    end

  end

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    migrate_from_guest
    session[:previous_url] || root_path
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      migrate_from_guest
      current_user
    else
      guest_user
    end
  end

  def guest_user
    session[:guest_user_id] ||= User.build_guest.id
    User.find_by_id session[:guest_user_id]
  end

  private

  def migrate_from_guest
    if session[:guest_user_id]
      hand_off_guest
      destroy_guest
    end
  end

  def destroy_guest
    guest_user.destroy
    session[:guest_user_id] = nil
  end

  # hand off resources from guest_user to current_user.
  def hand_off_guest
    guest_orders = guest_user.orders.all
    guest_orders.each do |order|
      order.user_id = current_user.id
      order.save
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

  # mobile devise helper
  def check_for_mobile
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    params.has_key?(:mobile) ?  true :
      (request.user_agent =~ /Mobile|webOS/) &&
      # treat iPad as non-mobile.
      (request.user_agent !~ /iPad/)
  end
  # enable this method both in all views / controllers
  helper_method :mobile_device?

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
