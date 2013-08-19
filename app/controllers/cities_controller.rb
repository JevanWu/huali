class CitiesController < ApplicationController
  respond_to :json

  def available_for_products
    if params[:product_ids].blank?
      render text: "Parameter product_ids is required", status: 400 and return
    end

    city_ids = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id)
        .region_rule.available_city_ids_in_a_prov(params[:prov_id])
    end.reduce(:&)

    cities = City.where(id: city_ids)
    respond_with(cities)
  end

  def index
    cities = Province.find(params[:prov_id]).cities
    respond_with(cities)
  end

  def show
    city = City.available.find params[:city_id]
    respond_with(city)
  end
end
