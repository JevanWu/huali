require 'spec_helper'

feature "List administrator" do
  given(:admin) { create(:administrator, email: 'admin@example.com') }
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    create(:administrator, email: 'admin1@example.com')
    create(:administrator, email: 'admin2@example.com')
  end

  scenario "Admin has not enough privilege" do
    login_as(admin, scope: :administrator)

    visit "/admin/administrators"

    page.should have_content('访问受限')
  end

  scenario "Admin has enough privilege" do
    login_as(super_admin, scope: :administrator)

    visit "/admin/administrators"

    page.should have_content('admin1@example.com')
    page.should have_content('admin2@example.com')
  end
end
