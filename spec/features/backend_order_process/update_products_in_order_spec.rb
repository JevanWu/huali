require 'spec_helper'

feature "Update products in order" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }

  background do
    login_as(admin, scope: :administrator)
    ship_method
  end

  scenario "which had used a coupon", js: true do
    o = create(:order, :wait_check, delivery_date: nil)
    o.coupon_code = create(:coupon_code).code
    OrderDiscountPolicy.new(o).apply

    visit "/admin/orders/#{o.id}/edit"

    within("form.order_admin_form") do
      fill_in '产品数量', with: 1, match: :first
      click_button('更新订单', match: :first)
    end

    o.reload
    o.total.should_not == o.item_total
  end

  scenario "whack had not use a coupon", js: true do
    o = create(:order, :wait_check, delivery_date: nil)

    visit "/admin/orders/#{o.id}/edit"

    within("form.order_admin_form") do
      fill_in '产品数量', with: 1, match: :first
      click_button('更新订单', match: :first)
    end

    o.reload
    o.total.should == o.item_total
  end
end

