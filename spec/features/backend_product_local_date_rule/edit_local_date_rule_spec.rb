require 'feature_spec_helper'

feature "Edit local date rule of product" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:user) }

  given(:product) { create(:product, :with_local_rules, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Edit successfully", js: true do
    visit "/admin/products/#{product.slug}/edit"

    fill_in '开始日期', with: '2013-07-01'
    click_button '更新产品'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      fill_in '到达日期', with: '2013-07-01'
      click_button '确定'
      page.should_not have_content('红宝石无法在该递送日期配送')

      fill_in '到达日期', with: '2013-01-01'
      click_button '确定'
      page.should have_content('红宝石无法在该递送日期配送')
    end
  end
end

