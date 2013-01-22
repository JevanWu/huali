class CitiesController < ApplicationController
  def index
    cities = Province.available.find_by_id(params[:prov_id]).cities.available

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
