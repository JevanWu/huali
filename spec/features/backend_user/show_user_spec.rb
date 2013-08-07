require 'spec_helper'

feature "Show user" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:user) { create(:user, email: 'user1@example.com') }

  scenario "Show user successfully" do
    visit "/admin/users/#{user.id}"

    page.should have_content('user1@example.com')
    page.should have_content('注册时间')
    page.should have_content('登录次数')
    page.should have_content('用户订单')
  end
end
