require 'spec_helper'

feature "Delete category" do
  given(:super_admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx', role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    user = create(:user, email: 'user1@example.com')

    visit "/admin/users"
    find("#user_#{user.id}").click_link("删除")
    page.driver.browser.switch_to.alert.accept

    page.should_not have_content('user1@example.com')
  end
end


