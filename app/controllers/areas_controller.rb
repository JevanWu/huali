class AreasController < ApplicationController
  def index
    areas = City.available.find_by_id(params[:city_id]).areas.available

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
