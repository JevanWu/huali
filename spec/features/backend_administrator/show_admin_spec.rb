require 'spec_helper'

feature "Show administrator" do
  given(:super_admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx', role: 'super') }

  given(:admin) { create(:administrator, email: 'admin1@example.com') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Show successfully" do
    visit "/admin/administrators/#{admin.id}"

    page.should have_content('admin1@example.com')
  end
end

