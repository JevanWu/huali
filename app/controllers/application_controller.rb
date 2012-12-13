class ApplicationController < ActionController::Base
  before_filter :set_locale, :check_for_mobile
  before_filter :dev_tools if Rails.env == 'development'

  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local

    rescue_from 'Exception' do |exception|
      render_error 500, exception
    end

    rescue_from 'ActionController::RoutingError', 'ActionController::UnknownController', '::AbstractController::ActionNotFound', 'ActiveRecord::RecordNotFound' do |exception|
      render_error 404, exception
    end

  end

  private

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
end
