class BannersController < ApplicationController
  respond_to :json

  def index
    if date_valid?
      @banners = Banner.fetch_by_date(params[:date])
      render json: @banners.to_json
    else
      render nothing: true
    end
  end

  private

  def date_valid?
    !! params[:date].to_date
  rescue
    false
  end
end

