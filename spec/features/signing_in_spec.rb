require_relative '../spec_helper'

feature "Signing in" do
  background do
    FactoryGirl.create(:user, email: 'user@example.com', password: 'caplin')
  end

  scenario "Signing in with correct credentials" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'caplin'
    end
    click_link '登录'
    save_and_open_page
    page.should have_content '登录成功'
  end

  given(:other_user) { User.new(email: 'other@example.com', password: 'rous') }

  scenario "Signing in with correct credentials" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', with: other_user.email
      fill_in 'user_password', with: other_user.password
    end
    click_link '登录'
    page.should have_content '登录成功'
  end
end