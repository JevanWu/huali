require 'feature_spec_helper'

feature "Edit coupon" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:coupon) { create(:coupon) }
  given(:coupon_code_record) { coupon.coupon_codes.first }

  scenario "Edit successfully" do
    visit "/admin/coupons/#{coupon.id}/edit"

    fill_in '优惠调整', with: '-200'
    fill_in '过期时间', with: '2013-08-01'
    fill_in '说明', with: '七夕促销'

    click_button '更新优惠券'

    page.should have_content(/优惠调整.*?-200/)
    page.should have_content(/说明.*?七夕促销/)
  end

  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }
  given(:product) do
    default_date_rule = create(:default_date_rule, start_date: nil)
    default_region_rule = create(:default_region_rule, province_ids: [province.id.to_s], city_ids: [city.id.to_s], area_ids: [area.id.to_s])
    create(:product,
           price: 299,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  given(:user) { create(:user) }

  scenario "Set as expired", js: true do
    visit "/admin/coupons/#{coupon.id}/edit"

    fill_in '过期时间', with: Date.current.yesterday.to_s

    click_button '更新优惠券'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"
    click_link '放入购物车'

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    fill_in '优惠券', with: coupon_code_record.code
    click_button '确定'

    page.should have_content('对不起，该优惠券已经过期或者无法使用')
  end

  scenario "Set as price conditioned", js: true do
    conditioned_coupon = create(:coupon, price_condition: 300).coupon_codes.first

    visit "/admin/coupons/#{coupon.id}/edit"

    click_button '更新优惠券'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"
    click_link '放入购物车'

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    fill_in '优惠券', with: conditioned_coupon.code
    click_button '确定'

    page.should have_content('对不起，该优惠券已经过期或者无法使用')
  end
end
