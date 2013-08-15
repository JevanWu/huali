class ProvincesController < ApplicationController
  respond_to :json

  def index
    provinces = Province.all
    respond_with(provinces)
  end

  def available_for_products
    if params[:product_ids].blank?
      render text: "Parameter product_ids is required", status: 400 and return
    end

    prov_ids = params[:product_ids].split(',').map do |product_id|
      Product.find(product_id).region_rule.available_prov_ids
    end.reduce(:&)

    provinces = Province.where(id: prov_ids)
    respond_with(provinces)
  end

  def show
    province = Province.available.find params[:prov_id]
    respond_with(province)
  end
end
