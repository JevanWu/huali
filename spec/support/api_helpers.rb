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
  def api(path)
    "/api/#{API::API.version}#{path}"
  end

  def json_response
    JSON.parse(response.body)
  end

  def import_region_data_from_files
    region_data = File.expand_path('../../fixtures/regions.sql', __FILE__)

    ActiveRecord::Base.connection.execute(File.read(region_data))
  end
end

# API request signing mock, there's no way to calculate Authentication headers in requests specs!
module API::APIHelpers
  private

  def valid_signature?
    true
  end
end
