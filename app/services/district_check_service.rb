class DistrictCheckService
  
  def initialize(city_id, address)
    @city_id = city_id
    @address = address
  end

  def inside?(region)
    return false unless [75].include?(@city_id.to_i) # Only for shanghai city centre

    x, y = BaiduGeocodingService.query_geo_by_address("上海", @address)
    position = BorderPatrol::Point.new(y, x)
    return true if region.contains_point?(position)

    return false
  end
end
