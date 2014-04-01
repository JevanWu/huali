require 'feature_spec_helper'

feature "Delete local region rule of product" do
  let(:admin) { create(:administrator) }

  given(:product) { create(:product, :with_local_rules, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    visit "/admin/products/#{product.slug}/edit"
    find("#region_rules").find_link('移除规则').click
    accept_confirm
    click_button '更新产品'

    visit "/admin/products/#{product.slug}/edit"

    find('#region_rule_province_ids', visible: false).value.should be_blank
    find('#region_rule_city_ids', visible: false).value.should be_blank
    find('#region_rule_area_ids', visible: false).value.should be_blank
  end
end
