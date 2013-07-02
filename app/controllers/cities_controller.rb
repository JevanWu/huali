class CitiesController < ApplicationController
  def index
    cities = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id).available_cities_of_province(params[:prov_id])
    end.reduce(:&)

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
