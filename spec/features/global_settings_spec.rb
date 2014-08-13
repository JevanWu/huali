require 'feature_spec_helper'

feature "Global settings" do

  background do
    prepare_home_page
  end

  scenario "Work time content" do
    Setting.work_time = "工作时间: 周一至周五9:30-18:30, 周末和法定节假日休息"

    visit "/"

    page.should have_content(Setting.work_time)
  end

end

feature "Date rule start_date setting" do

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


  scenario "start_date was set", js: true do
    Setting.date_rule_start_date = 5.days.since.to_date

    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '到达日期', with: 4.days.since.to_date
      click_button '确定'
    end

    page.should have_content('红宝石无法在该递送日期配送')

    within("#new-order") do
      fill_in '到达日期', with: 6.days.since.to_date
      click_button '确定'
    end

    page.should_not have_content('红宝石无法在该递送日期配送')
  end

  scenario "No start_date was set", js: true do
    Setting.date_rule_start_date = ""

    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '到达日期', with: Date.current
      click_button '确定'
    end

    page.should_not have_content('红宝石无法在该递送日期配送')
  end
end
