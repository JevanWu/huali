require 'spec_helper'

feature "Delete administrator" do
  given(:super_admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx', role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    admin = create(:administrator, email: 'admin1@example.com')

    visit "/admin/administrators"
    find("#administrator_#{admin.id}").click_link("删除")
    page.driver.browser.switch_to.alert.accept

    page.should_not have_content('admin1@example.com')
  end
end

