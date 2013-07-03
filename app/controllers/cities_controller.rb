class CitiesController < ApplicationController
  def available_for_products
    city_ids = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id)
        .region_rule.available_city_ids_in_a_prov(params[:prov_id])
    end.reduce(:&)

    cities = City.find_all_by_id(city_ids)

    respond_to do |format|
      format.json { render json: cities }
    end
  end

  def index
    cities = City.all

    respond_to do |format|
      format.json { render json: cities }
    end
  end

  def show
    city = City.available.find params[:city_id]

    respond_to do |format|
      format.json { render json: city }
    end
  end
end
