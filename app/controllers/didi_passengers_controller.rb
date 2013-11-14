class DidiPassengersController < ApplicationController
  layout 'mobile'

  def new
    @didi_passenger = DidiPassenger.new
  end

  def create
    @didi_passenger = DidiPassenger.new(permitted_params[:didi_passenger])

    if @didi_passenger.save
      #TODO: generate a coupon code and sent it to he phone
      flash[:notice] = "优惠劵已发送到手机"
      redirect_to collection_products_path("impression-collection-flower-in-photo-frame")
    else
      render 'new'
    end
  end

  private

  def permitted_params
    params.permit(didi_passenger: [ { phone: [] }, :terms_of_service])
  end
end

