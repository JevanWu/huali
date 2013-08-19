require 'spec_helper'

feature "Edit user info" do
  given(:user) { create(:user, email: 'user@hua.li', password: 'aaa123', password_confirmation: 'aaa123') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')

    login_as(user, scope: :user)
  end

  scenario "Wrong current password" do
    visit '/users/edit'

    fill_in '邮箱', with: 'new@example.com'
    fill_in '密码', with: 'new_password', match: :first
    fill_in '确认密码', with: 'new_password'
    fill_in '当前密码', with: ''
    click_button '更新'

    page.should have_content('Current password 您需要填写此项')
  end

  scenario "Update successfully" do
    visit '/users/edit'

    fill_in '邮箱', with: 'new@example.com'
    fill_in '密码', with: 'new_password', match: :first
    fill_in '确认密码', with: 'new_password'
    fill_in '当前密码', with: 'aaa123'
    click_button '更新'

    page.should have_content('帐号资料更新成功')
  end
end
