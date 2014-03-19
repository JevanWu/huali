require 'feature_spec_helper'

feature "Delete local date rule of product" do
  let(:admin) { create(:administrator) }

  given(:product) { create(:product, :with_local_rules, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    visit "/admin/products/#{product.slug}/edit"
    find("#date_rules").find_link('移除规则').click
    accept_confirm
    click_button '更新产品'

    visit "/admin/products/#{product.slug}/edit"

    page.should_not have_content('开始日期')
    page.should_not have_content('周期长度')
    page.should_not have_content('包含日期')
    page.should_not have_content('排除日期')
  end
end
