module API
  module APIHelpers
    SIGN_HEADER = "SIGN"
    SIGN_PARAM = :sign

    def paginate(object)
      object.page(params[:page]).per(params[:per_page].to_i)
    end

    def authenticate!
      unauthorized! unless verify_sign?
    end

    # error helpers

    def forbidden!
      render_api_error!('403 Forbidden', 403)
    end

    def bad_request!(validation_errors)
      render_api_error!("400 (Bad request)", 400, validation_errors)
    end

    def not_found!(resource = nil)
      message = ["404"]
      message << resource if resource
      message << "Not Found"
      render_api_error!(message.join(' '), 404)
    end

    def unauthorized!
      render_api_error!('401 Unauthorized', 401)
    end

    def not_allowed!
      render_api_error!('Method Not Allowed', 405)
    end

    def render_api_error!(message, status, extra_messages = {})
      error!({'message' => message}.merge(extra_messages), status)
    end

    private

    def verify_sign?
      #TODO: Impelement the signature verifing
    end
  end
end

