module API
  module APIHelpers
    SIGN_HEADER = "Sign"
    SIGN_PARAM = :sign

    def guest_user
      @guest_user ||= User.build_guest
    end

    def paginate(object)
      object.page(params[:page]).per(params[:per_page].to_i)
    end

    def verify_signature!
      unauthorized! unless valid_signature?
    end

    # error helpers

    def forbidden!
      render_api_error!('403 Forbidden', 403)
    end

    def validation_error!(model)
      render_api_error!("400 (Bad request)", 400, model.errors.messages)
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

    def valid_signature?
      signer = HmacSignature.new(ENV['API_SIGNING_SECRET'])

      query_params = request.params.except(:route_info, :sign, :id)

      sig  = request.headers[SIGN_HEADER] || request.params[SIGN_PARAM]

      sig == signer.sign(query_params) #&& (Time.current.to_i - params[:timestamp].to_i) < 120
    end
  end
end

