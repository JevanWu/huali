class AreasController < ApplicationController
  def index
    areas = City.find_by_id(params[:city_id]).areas

    respond_to do |format|
      format.json { render json: areas }
    end
  end

  def show
    area = Area.find_by_id params[:area_id]

    respond_to do |format|
      format.json { render json: area }
    end
  end
end
