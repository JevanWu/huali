module Extension
  module Exception
    extend ActiveSupport::Concern
    # include Squash::Ruby::ControllerMethods

    included do
      if Rails.env.production?
        rescue_from 'Exception' do |exception|
          # notify_squash(exception)
          render_error 500, exception
        end

        rescue_from 'ActionController::RoutingError',
          'ActionController::UnknownController',
          '::AbstractController::ActionNotFound' do |exception|
          # notify_squash(exception)
          render_error 404, exception
        end

        rescue_from 'ActiveRecord::RecordNotFound',
          'ActionController::UnknownFormat' do |exception|
          unless params[:controller] == 'pages' && params[:action] == "show"
            # notify_squash(exception)
          end

          render_error 404, exception
        end
      end
    end

    private

    def render_error(status, exception)
      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/error', status: status }
        format.mobile { render template: "errors/error_#{status}", layout: 'layouts/error', status: status }
        format.json { render nothing: true, status: status }
      end
    end
  end
end
