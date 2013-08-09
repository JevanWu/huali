require 'spec_helper'

feature "Delete product" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    product = create(:product, name_zh: '红宝石')

    visit "/admin/products"
    find("#product_#{product.id}").click_link("删除")
    page.driver.browser.switch_to.alert.accept

    page.should_not have_content('红宝石')
  end
end
