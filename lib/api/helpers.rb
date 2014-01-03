module API
  module APIHelpers
    SIGN_HEADER = "SIGN"
    SIGN_PARAM = :sign

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

    def valid_signature?
      signer = HmacSignature.new(ENV['API_SIGNING_SECRET'])

      verb = request.request_method
      host = request.host
      path = request.path
      query_params = request.params.reject do |k, _|
        request.path_parameters.keys.include?(k.to_sym) || k.to_sym == SIGN_PARAM
      end

      sig  = request.headers[SIGN_HEADER] || request.params[SIGN_PARAM]

      sig == signer.sign(verb, host, path, query_params) #&& (Time.current.to_i - params[:timestamp].to_i) < 120
    end
  end
end

