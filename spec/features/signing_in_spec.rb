require_relative '../spec_helper'

feature "Signing in" do
  before(:each) do
    FactoryGirl.create(:user, email: 'user@example.com', password: 'caplin')
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario "Signing in with correct credentials", js: true do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'caplin'
      click_on '登录'
    end
    page.find('#flash_notice').should have_content '登录成功'
  end

  given(:non_exist_user) { User.new(email: 'non_exist_user@example.com', password: 'rous') }

  scenario "Signing in with non exist user" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', with: non_exist_user.email
      fill_in 'user_password', with: non_exist_user.password
      click_on '登录'
    end
    page.find('#flash_alert').should have_content '此用户不存在'
  end

  given(:other_user) { User.new(email: 'user@example.com', password: 'rous') }
  
  scenario "Signing in with non exist user" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', with: other_user.email
      fill_in 'user_password', with: other_user.password
      click_on '登录'
    end
    page.find('#flash_alert').should have_content '邮箱或密码错误'
  end
end