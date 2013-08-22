require 'spec_helper'

feature "Forgot password" do
  background do
    create(:user, email: 'user@hua.li')
  end

  scenario "Email not found" do
    visit '/users/password/new'

    fill_in '邮箱', with: 'non_exist_email@example.com'

    click_button '重设密码'

    page.should have_content('邮箱 没有找到')
  end

  scenario "Forgot successfully" do
    visit '/users/password/new'

    fill_in '邮箱', with: 'user@hua.li'

    click_button '重设密码'

    page.should have_content('几分钟后，您将收到重置密码的电子邮件.')
  end
end

feature "Update password with reset password token" do
  given(:user) { create(:user, email: 'user@hua.li') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
    user

    visit '/users/password/new'
    fill_in '邮箱', with: 'user@hua.li'
    click_button '重设密码'
  end

  scenario "Token invalid" do
    visit '/users/password/edit?reset_password_token=wrong_token'

    fill_in '密码', with: 'new_password', match: :first
    fill_in '确认密码', with: 'new_password'

    click_button '更改我的密码'

    page.should have_content('Reset password token 是无效的')
  end

  scenario "Update with right reset token" do
    visit "/users/password/edit?reset_password_token=#{user.reload.reset_password_token}"

    fill_in '密码', with: 'new_password', match: :first
    fill_in '确认密码', with: 'new_password'

    click_button '更改我的密码'

    page.should have_content('您的密码已修改成功，您现在已登录')
  end
end
