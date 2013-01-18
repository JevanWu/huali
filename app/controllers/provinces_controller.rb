class ProvincesController < ApplicationController
  def index
    provinces = Province.available

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
