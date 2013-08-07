require 'spec_helper'

feature "Edit login and password for user" do
  given(:admin) { create(:administrator, email: 'admin@example.com', password: 'admin123', password_confirmation: 'admin123') }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:user) { create(:user, email: 'user1@example.com') }

  scenario "Edit successfully" do
    visit "/admin/users/#{user.id}/edit"

    fill_in '邮箱', with: 'user2@example.com'
    fill_in '密码', with: 'aaa123'
    click_button '更新用户'

    page.should have_content('user2@example.com')
  end

  scenario "Validation errors" do
    visit "/admin/users/#{user.id}/edit"

    fill_in '邮箱', with: ''
    click_button '更新用户'

    page.should have_content('邮箱 您需要填写此项')
    page.should have_content('密码 您需要填写此项')
  end
end
