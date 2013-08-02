require_relative '../spec_helper'

feature "Placing order" do
  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }
  let(:user) { create(:user, email: 'user@example.com', password: 'caplin') }
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'admin', password_confirmation: 'admin') }

  before(:each) do
    login_as(user, scope: :user)
  end

  background do
  end

  given(:product) do
    default_date_rule = create(:default_date_rule, start_date: nil)
    default_region_rule = create(:default_region_rule, province_ids: [province.id], city_ids: [city.id], area_ids: [area.id])
    create(:product,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  scenario "Placing order", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购花篮')

    within(".order-actions") do
      click_link('确定')
    end

    within("#new-order") do
      select("人人", from: "order_source")
      fill_in('到达日期', with: '2013-08-10')
      fill_in('收件人', with: '王二')
      fill_in('电话', with: '18800001111', match: :prefer_exact)
      select('上海市', from: '省份')
      select('市辖区', from: '城市')
      select('虹口区', from: '区域')
      fill_in('地址', with: 'xx路xx号')
      fill_in('邮编', with: '201208')
      click_button('确定')
    end

    login_as(admin, scope: :admin)

    visit '/admin/orders'

    find("#index_table_orders").find("tbody a").click

    page.should have_content('normal')
    page.should have_content('等待付款')
    page.should have_content(/QR\d+/)
    page.should have_content(/红宝石\s*x\s*1/)
    page.should have_content('上海市')
    page.should have_content('市辖区')
    page.should have_content('虹口区')
    page.should have_content('18800001111')
    page.should have_content(/¥\s*#{product.price}/)
  end
end
