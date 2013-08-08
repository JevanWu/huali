require 'spec_helper'

feature "Delete ship method" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    ship_method = create(:ship_method, name: 'UPS')

    visit "/admin/ship_methods"
    find("#ship_method_#{ship_method.id}").click_link("删除")
    page.driver.browser.switch_to.alert.accept

    page.should_not have_content('UPS')

    visit '/admin/shipments/new'
    page.find("#shipment_ship_method_input").should_not have_content('UPS')
  end
end

