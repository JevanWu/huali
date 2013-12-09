require 'spec_helper'

feature 'Use coupon' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石', price: 200) }
  given(:coupon_code_record) { create(:coupon).coupon_codes.first }

  background do
    prepare_home_page
  end

  scenario 'Invalid coupon code', js: true do
    coupon_code_record.coupon.update_column(:expired, true)

    visit "/orders/current/#{coupon_code_record}/products/#{product.slug}"

    page.should have_content("产品已售尽")
  end

  scenario 'Product is sold out', js: true do
    product.update_column(:count_on_hand, 0)

    visit "/orders/current/#{coupon_code_record}/products/#{product.slug}"

    page.should have_content("产品已售尽")
  end

  scenario 'Successfully get product discount', js: true do
    visit "/orders/current/#{coupon_code_record}/products/#{product.slug}"

    page.should_not have_content("产品已售尽")
    page.should have_content("红宝石")
    page.should have_content("200")
  end
end
