module MobileAPI
  class Addresses < Grape::API
    resource :addresses do
      desc "Return all provinces." 
      get :provinces do
        provinces = Province.where(available: true)
        res = Array.new
        provinces.each do |province|
          province_info = { id: province.id, name: province.name, post_code: province.post_code }
          res << province_info
        end
        res
      end

      desc "Return all cities of specified province." 
      params do
        requires :province_id, type: Integer, desc: "The id of the province"
      end
      get :cities do
        province = Province.find params[:province_id]
        cities = province.cities.where(available: true)
        res = Array.new
        cities.each do |city|
          city_info = { id: city.id, name: city.name, post_code: city.post_code }
          res << city_info
        end
        res
      end

      desc "Return all areas of specified city." 
      params do
        requires :city_id, type: Integer, desc: "The id of the city"
      end
      get :areas do
        city = City.find params[:city_id]
        areas = city.areas.where(available: true)
        res = Array.new
        areas.each do |area|
          area_info = { id: area.id, name: area.name, post_code: area.post_code }
          res << area_info
        end
        res
      end
    end
  end
end
