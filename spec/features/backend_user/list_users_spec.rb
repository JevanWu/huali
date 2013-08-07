require 'spec_helper'

feature "List users" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)

    create(:user, email: 'user1@example.com')
    create(:user, email: 'user2@example.com')
  end

  scenario "List users successfully" do
    visit "/admin/users"

    page.should have_content('user1@example.com')
    page.should have_content('user2@example.com')
  end
end
