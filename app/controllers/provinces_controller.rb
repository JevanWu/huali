class ProvincesController < ApplicationController
  def index
    provinces = Province.all

    respond_to do |format|
      format.json { render json: provinces }
    end
  end

  def available_for_products
    if params[:product_ids].blank?
      render text: "Parameter product_ids is required", status: 400 and return
    end

    prov_ids = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id).region_rule.available_prov_ids
    end.reduce(:&)

    provinces = Province.find_all_by_id(prov_ids)

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
