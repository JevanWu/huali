module MobileAPI
  class Addresses < Grape::API
    resource :addresses do
      #product_ids: [ 1, 2, 3]
      desc "Return all provinces." 
      get :provinces do

        prov_ids = params[:product_ids].map do |product_id|
          Product.find(product_id).region_rule.available_prov_ids
        end.reduce(:&)

        provinces = Province.where(id: prov_ids)

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
        city_ids = params[:product_ids].map do |product_id|
          Product.find(product_id)
            .region_rule.available_city_ids_in_a_prov(params[:province_id])
        end.reduce(:&)

        cities = City.where(id: city_ids)

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
        area_ids = params[:product_ids].map do |product_id|
          Product.find(product_id)
            .region_rule.available_area_ids_in_a_city(params[:city_id])
        end.reduce(:&)

        areas = Area.where(id: area_ids)

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
