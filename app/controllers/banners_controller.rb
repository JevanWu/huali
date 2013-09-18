class BannersController < ApplicationController
  respond_to :json

  def index
    begin
      @banners = Banner.fetch_by_date(params[:date])
      render json: @banners.to_json
    rescue
      render nothing: true
    end
  end
end

