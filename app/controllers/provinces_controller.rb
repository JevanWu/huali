class ProvincesController < ApplicationController
  def index
    provinces = Province.all

    respond_to do |format|
      format.json { render json: provinces }
    end
  end

  def show
    province = Province.find params[:prov_id]

    respond_to do |format|
      format.json { render json: province }
    end
  end
end
