require 'spec_helper'

feature "Delete user account" do
  given(:user) { create(:user, email: 'user@example.com', password: 'aaa123', password_confirmation: 'aaa123') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')

    login_as(user, scope: :user)
  end

  scenario "Delete successfully", js: true do
    visit '/users/edit'

    click_on '取消我的帐户'
    accept_confirm

    page.should have_content('再见！您的帐户已成功注销。我们希望很快可以再见到您')

    logout(:user)

    visit '/users/sign_in'

    within("#new_user") do
      fill_in '邮箱', with: 'user@example.com'
      fill_in '密码', with: 'aaa123'
      click_on '登录'
    end

    page.should have_content('此用户不存在')
  end
end

