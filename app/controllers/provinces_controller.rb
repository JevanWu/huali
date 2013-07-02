class ProvincesController < ApplicationController
  def index
    provinces = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id).available_provinces
    end.reduce(:&)

    respond_to do |format|
      format.json { render json: provinces }
    end
  end

  def show
    province = Province.available.find params[:prov_id]

    respond_to do |format|
      format.json { render json: province }
    end
  end
end
