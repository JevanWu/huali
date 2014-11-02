class BaiduGeocodingService
  def self.query_geo_by_address(city, address)
    counter = 1

    begin
      ret = RestClient.get 'http://api.map.baidu.com/geocoder/v2/', { params: { output: 'json', ak: 'YfSD9imvBR5whRMDglHaGhsq', city: city, address: address } }
      ret = JSON.parse(ret)
      localtion = ret["result"]["location"]
      return localtion["lat"], localtion["lng"]
    rescue
      if counter < 3
        counter += 1
        retry
      end
    end

    return 0, 0
  end
end
