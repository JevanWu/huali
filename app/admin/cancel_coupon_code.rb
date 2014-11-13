ActiveAdmin.register_page "Cancel Coupon Code" do
  menu parent: '设置'

  page_action :operate, method: :get do
  end

  page_action :cancel, method: :post do
    code = CouponCode.find_by code: params[:coupon_code]
    while code.available_count > 0
      code.use!
    end

    redirect_to admin_root_path, flash: { success: "The coupon code #{params[:coupon_code]} has been cancelled" }
  end

  action_item do
    link_to "注销优惠码", admin_cancel_coupon_code_operate_path, :method => :get
  end
end
