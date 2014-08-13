require 'feature_spec_helper'

feature 'Edit default date rule' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  let(:province) { create(:province, name: '上海市') }
  let(:city) { create(:city, name: '市辖区', province: province) }
  let(:area) { create(:area, name: '虹口区', city: city) }
  let(:user) { create(:user) }

  given(:default_date_rule) { create(:default_date_rule) }
  given(:product) do
    default_region_rule = create(:default_region_rule, province_ids: [province.id.to_s], city_ids: [city.id.to_s], area_ids: [area.id.to_s])
    create(:product,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  scenario "Edit successfully", js: true do
    visit "/admin/default_date_rules/#{default_date_rule.id}/edit"

    fill_in '开始日期', with: '2013-08-01'
    fill_in '周期长度', with: '+2M'
    fill_in '包含日期', with: '2013-07-19,2013-07-20'
    fill_in '排除日期', with: '2013-08-10,2013-09-01'
    check 'Monday'
    fill_in '规则名称', with: '规则1'

    click_button '更新默认递送时间规则'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"

    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    ['2013-08-10', '2013-08-12', '2013-09-01', '2013-11-01'].each do |date|
      fill_in '到达日期', with: date
      click_button '确定'

      page.should have_content('红宝石无法在该递送日期配送')
    end

    ['2013-07-19', '2013-07-20', '2013-08-01', '2013-09-03'].each do |date|
      fill_in '到达日期', with: date
      click_button '确定'

      page.should_not have_content('红宝石无法在该递送日期配送')
    end
  end
end
