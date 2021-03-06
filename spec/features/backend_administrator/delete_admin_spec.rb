require 'feature_spec_helper'

feature "Delete administrator" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    admin = create(:administrator, email: 'admin1@example.com')

    visit "/admin/administrators"
    find("#administrator_#{admin.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('admin1@example.com')
  end
end

