class BaiduGeocodingService
  def self.query_geo_by_address(city, address)
    RestClient.get 'http://api.map.baidu.com/geocoder/v2/', { params: { output: 'json', ak: 'YfSD9imvBR5whRMDglHaGhsq', city: city, address: address } }
  end
end
