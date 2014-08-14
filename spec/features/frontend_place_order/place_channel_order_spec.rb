require 'feature_spec_helper'

feature 'Place order' do
  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }

  given(:admin) { create(:administrator) }

  given(:product) do
    default_date_rule = create(:default_date_rule, start_date: Date.current)
    default_region_rule = create(:default_region_rule, province_ids: [province.id.to_s], city_ids: [city.id.to_s], area_ids: [area.id.to_s])
    create(:product,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  background do
    prepare_home_page

    login_as(admin, scope: :administrator)
    create(:ship_method, name: '人工递送')
  end

  scenario "Validation errors", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('渠道订单')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      choose "腾讯"
      choose "人工递送"
      fill_in '到达日期', with: "2012-12-12"
      fill_in '发货日期', with: "2012-12-11"
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '新增订单'
    end

    page.should have_content('红宝石无法在该递送日期配送')
  end

  scenario "Validating taobao transaction number", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('渠道订单')
    end

    within("#new-order") do
      choose "淘宝"
      fill_in '支付宝交易号', with: '38375784-34-08-543578394'

      click_button '新增订单'
    end

    page.should have_content('无效的淘宝交易号码')
  end

  scenario "Placed successfully", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('渠道订单')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      choose "淘宝"
      fill_in '支付宝交易号', with: '2013092600001000160047724202'
      choose "人工递送"
      fill_in '到达日期', with: Date.current
      fill_in '发货日期', with: Date.current.yesterday
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '新增订单'
    end

    page.should have_content('您已经成功创建订单和地址信息')
  end
end
