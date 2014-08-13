require 'feature_spec_helper'

feature "Add local region rule to product" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:user) }

  given(:product) { create(:product, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
    import_region_data_from_files
  end

  scenario "Added successfully", js: true do
    visit "/admin/products/#{product.slug}/edit"

    find('.add_region_rule').click
    check_and_open_child('广东省')
    check_and_open_child('广州市')
    uncheck '天河区'
    close_region_popups
    click_button '更新产品'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      select('广东省', from: '省份')
      page.should have_content('广州市')

      select('广州市', from: '城市')
      page.should have_content('越秀区')
      page.should_not have_content('天河区')
      select('越秀区', from: '地区')

      click_button '确定'
    end

    page.should_not have_content('红宝石无法配送到该区域')
  end
end

