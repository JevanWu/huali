require 'spec_helper'

feature "Add coupon" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Validation errors" do
    visit "/admin/coupons/new"
    fill_in "优惠调整", with: '*0.9'
    click_button "创建优惠券"

    page.find("#coupon_expires_at_input").should have_content('您需要填写此项')
  end

  scenario "Ajustment format error" do
    visit "/admin/coupons/new"
    fill_in "优惠调整", with: '*xx0.9'
    fill_in "过期时间", with: '2013-01-01'
    fill_in "优惠券数量", with: '1'
    fill_in "优惠券有效使用次数", with: '500'
    click_button "创建优惠券"

    page.find("#coupon_adjustment_input").should have_content('是无效的')
  end

  scenario "Added successfully" do
    visit "/admin/coupons/new"
    fill_in "优惠调整", with: '-100'
    fill_in "过期时间", with: '2013-01-01'
    fill_in "优惠券数量", with: '1'
    fill_in "优惠券有效使用次数", with: '500'
    click_button "创建优惠券"

    page.should have_content(/优惠调整.*?-100/)
  end
end
