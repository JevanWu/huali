class InstantDeliveryCheckService
  attr_reader :city_id, :address

  def initialize(city_id, address)
    @city_id = city_id
    @address = address
  end

  def check
    return false unless [75].include?(city_id.to_i) # Only for shanghai city centre

    x, y = BaiduGeocodingService.query_geo_by_address("上海", address)
    position = BorderPatrol::Point.new(y, x)

    if $ljz_region.contains_point?(position) || $jingan_region.contains_point?(position) || $huangpu_region.contains_point?(position) || $huangpu2_region.contains_point?(position)
      return true if InstantDelivery.used_count_today < 24
    end

    return false
  end
end
