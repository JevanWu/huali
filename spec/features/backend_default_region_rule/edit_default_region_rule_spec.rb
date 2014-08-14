require 'feature_spec_helper'

feature 'Edit default region rule' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    import_region_data_from_files
  end

  let(:user) { create(:user) }

  given(:default_date_rule) { create(:default_date_rule) }
  given(:default_region_rule) { create(:default_region_rule) }
  given(:product) do
    create(:product,
           name_en: 'ruby',
           name_zh: '红宝石',
           default_date_rule: default_date_rule,
           default_region_rule: default_region_rule)
  end

  scenario "Edit successfully", js: true do
    visit "/admin/default_region_rules/#{default_region_rule.id}/edit"

    fill_in '规则名称', with: '规则1'
    check_and_open_child('广东省')
    check_and_open_child('广州市')
    uncheck '天河区'
    close_region_popups

    click_button '更新默认递送地域规则'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"

    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    page.should_not have_content('上海市')

    within("#new-order") do
      select('广东省', from: '省份')
      select('广州市', from: '城市')
      page.should_not have_content('天河区')

      select('越秀区', from: '地区')
    end

    click_button '确定'

    page.should_not have_content('红宝石无法配送到该区域')
  end
end
