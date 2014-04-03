require 'feature_spec_helper'

feature "Delete user" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    user = create(:user, email: 'user1@example.com')

    visit "/admin/users"
    find("#user_#{user.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('user1@example.com')
  end
end


