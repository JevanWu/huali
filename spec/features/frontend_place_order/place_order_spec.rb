require 'feature_spec_helper'

feature 'Place order' do
  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }

  given(:user) { create(:user) }

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

    login_as(user, scope: :user)
  end

  scenario "Validation errors", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      select '搜索引擎', from: '来源'
      fill_in '到达日期', with: "2012-12-12"
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '确定'
    end

    page.should have_content('红宝石无法在该递送日期配送')
  end

  scenario "Placed successfully", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      select '搜索引擎', from: '来源'
      fill_in '到达日期', with: Date.current
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '确定'
    end

    page.should have_content('您已经成功创建订单和地址信息')
  end

  scenario "Out of stock after put into cart", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')

    product.update_attribute(:count_on_hand, 0)

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      select '搜索引擎', from: '来源'
      fill_in '到达日期', with: Date.current
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '确定'
    end

    page.should have_content('红宝石库存不足')
  end

  given(:coupon_code_record) { create(:coupon, adjustment: "-#{product.price}").coupon_codes.first }

  scenario "Order has a total price of 0", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购物车')


    find("input[name='coupon_code']").set(coupon_code_record.code)
    within(".discount") do
      click_button '确定'
    end

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '寄件人姓名', with: '王二'
      fill_in '寄件人邮箱', with: 'user@example.com'
      fill_in '寄件人电话', with: '18011112222'
      select '搜索引擎', from: '来源'
      fill_in '到达日期', with: Date.current
      fill_in '收件人姓名', with: '王二'
      fill_in '收件人电话', with: '18011112222'

      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '地区')

      fill_in '地址', with: 'xx路xx号'
      fill_in '邮编', with: '201218'

      click_button '确定'
    end

    page.should have_content('您已经成功创建订单和地址信息')
    page.should have_content("等待审核")
  end

end
