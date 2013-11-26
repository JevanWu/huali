class DidiPassengersController < ApplicationController
  layout 'mobile'

  def new
    @didi_passenger = DidiPassenger.new
  end

  def create
    @didi_passenger = DidiPassenger.new(permitted_params[:didi_passenger])

    if @didi_passenger.save
      begin
        @coupon = Coupon.find_by_note!("嘀嘀打车合作")

        DidiPassengerReceiveCouponService.receive_coupon_code(@didi_passenger, @coupon)

        cookies[:coupon_code] = @didi_passenger.coupon_code.code

        flash[:notice] = "现金代码已发送至您手机。"
        redirect_to collection_products_path("latest-design")
      rescue ArgumentError, ActiveRecord::RecordNotFound
        flash[:notice] = "抱歉，该活动已结束"
        redirect_to collection_products_path("latest-design")
      end
    else
      render 'new'
    end
  end

  private

  def permitted_params
    params.permit(didi_passenger: [ { phone: [] }])
  end
end

