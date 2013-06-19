class AreasController < ApplicationController
  def index
    areas = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id).available_areas_of_city(params[:city_id])
    end.reduce(:&)

    respond_to do |format|
      format.json { render json: areas }
    end
  end

  def show
    area = Area.available.find_by_id params[:area_id]

    respond_to do |format|
      format.json { render json: area }
    end
  end
end
