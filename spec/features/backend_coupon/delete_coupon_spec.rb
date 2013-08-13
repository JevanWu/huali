require 'spec_helper'

feature "Delete coupon" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    coupon = create(:coupon, note: '七夕促销')

    visit "/admin/coupons"
    find("#coupon_#{coupon.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('七夕促销')
  end
end

