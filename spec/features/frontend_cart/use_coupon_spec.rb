require 'feature_spec_helper'

feature 'Use coupon' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石', price: 200) }
  given(:coupon_code_record) { create(:coupon).coupon_codes.first }
  given(:user) { create(:user) }

  background do
    prepare_home_page
    login_as(user, scope: :user)
  end

  scenario 'Invalid coupon code', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购物车'

    find("input[name='coupon_code']").set('00000000')
    within(".discount") do
      click_button '确定'
    end

    page.should have_content("无效优惠码！请确认信息后输入")
  end

  scenario 'Use successfully', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购物车'

    find("input[name='coupon_code']").set(coupon_code_record.code)
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

  scenario "Coupon code has price condition", js: true do
    coupon_code_record = create(:coupon, price_condition: (product.price + 1).to_i).coupon_codes.first

    visit "/products/#{product.slug}"

    click_link '放入购物车'

    find("input[name='coupon_code']").set(coupon_code_record.code)
    within(".discount") do
      click_button '确定'
    end

    page.should have_content("无效优惠码！请确认信息后输入")
  end

  scenario "Coupon code has products limitation", js: true do
    coupon_code_record = create(:coupon, :with_products_limitation).coupon_codes.first

    visit "/products/#{product.slug}"

    click_link '放入购物车'

    find("input[name='coupon_code']").set(coupon_code_record.code)
    within(".discount") do
      click_button '确定'
    end

    page.should have_content("无效优惠码！请确认信息后输入")
  end
end

