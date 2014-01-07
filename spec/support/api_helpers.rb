module ApiHelpers
  # Public: Prepend a request path with the path to the API
  #
  # path - Path to append
  # user - User object - If provided, automatically appends private_token query
  #          string for authenticated requests
  #
  # Examples
  #
  #   >> api('/issues')
  #   => "/api/v2/issues"
  #
  #   >> api('/issues', User.last)
  #   => "/api/v2/issues?private_token=..."
  #
  #   >> api('/issues?foo=bar', User.last)
  #   => "/api/v2/issues?foo=bar&private_token=..."
  #
  # Returns the relative path to the requested API resource
  def api(path, request_params = nil)
    "/api/#{API::API.version}#{path}" +

      # Normalize query string
      (path.index('?') ? '' : '?') +

      # Append private_token if given a User object
      ("&sign=#{request_sign(request_params)}")
  end

  def json_response
    JSON.parse(response.body)
  end

  private

  def request_sign(request_params)
    signer = API::HmacSignature.new(ENV['API_SIGNING_SECRET'])
    sign = signer.sign(request_params.to_h)
    CGI.escape(sign)
  end
end
