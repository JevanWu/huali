class AreasController < ApplicationController
  respond_to :json

  def available_for_products
    if params[:product_ids].blank?
      render text: "Parameter product_ids is required", status: 400 and return
    end

    area_ids = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id)
        .region_rule.available_area_ids_in_a_city(params[:city_id])
    end.reduce(:&)

    areas = Area.where(id: area_ids)
    respond_with(areas)
  end

  def index
    areas = City.find(params[:city_id]).areas
    respond_with(areas)
  end

  def show
    area = Area.available.find_by_id params[:area_id]
    respond_with(area)
  end
end
