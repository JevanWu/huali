require 'spec_helper'

feature 'Use coupon' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石', price: 200) }
  given(:coupon) { create(:coupon) }
  given(:user) { create(:user) }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
    login_as(user, scope: :user)
  end

  scenario 'Invalid coupon code', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    find("input[name='coupon_code']").set('00000000')
    within(".discount") do
      click_button '确定'
    end

    page.should have_content("无效优惠码！请确认信息后输入")
  end

  scenario 'Use successfully', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    find("input[name='coupon_code']").set(coupon.code)
    within(".discount") do
      click_button '确定'
    end

    page.should_not have_content("无效优惠码！请确认信息后输入")
    find(".subtotal").should have_content("180")

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    page.should have_content(/折后总计.*180/)
  end
end

