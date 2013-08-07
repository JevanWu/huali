require 'spec_helper'

feature "Choosing delivery region" do
  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }
  let(:user) { create(:user, email: 'user@example.com', password: 'caplin', name: '王二') }

  before(:each) do
    login_as(user, scope: :user)
  end

  given(:product) do
    default_date_rule = create(:default_date_rule, start_date: nil)
    default_region_rule = create(:default_region_rule, province_ids: [province.id.to_s], city_ids: [city.id.to_s], area_ids: [area.id.to_s])
    create(:product,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  scenario "Choose sucessfully", js: true do
    visit "/products/#{product.slug}"
    click_link('放入购花篮')

    within(".order-actions") do
      click_link('确定')
    end

    within("#new-order") do
      select('上海市', from: '省份')
      page.should have_content('市辖区')

      select('市辖区', from: '城市')
      page.should have_content('虹口区')

      select('虹口区', from: '区域')
    end
  end
end
