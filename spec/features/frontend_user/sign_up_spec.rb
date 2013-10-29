require 'spec_helper'

feature "Sign up" do
  background do
    prepare_home_page
  end

  scenario "Sign up successfully", js: true do
    visit '/users/sign_up'
    within("#new_user") do
      fill_in '邮箱', with: 'user@example.com'
      fill_in '密码', with: 'caplin', match: :first
      fill_in '确认密码', with: 'caplin'
      fill_in '您的联系方式', with: '18011112222'

      fill_in 'user_humanizer_answer', with: '4'
      page.execute_script("$('#user_humanizer_question_id').val('0')")

      click_button '注册'
    end

    page.should have_content('欢迎您！您已注册成功.')
  end

  scenario "Validation errors", js: true do
    create(:user, email: 'user@example.com')

    visit '/users/sign_up'
    within("#new_user") do
      fill_in '邮箱', with: 'user@example.com'
      fill_in '密码', with: 'caplin', match: :first
      fill_in '确认密码', with: 'caplin1'
      fill_in '您的联系方式', with: '18011112222'

      fill_in 'user_humanizer_answer', with: '4'
      page.execute_script("$('#user_humanizer_question_id').val('1')")

      click_button '注册'
    end

    page.should have_content('邮箱 已经被使用')
    page.should have_content('密码 与确认值不匹配')
    page.should have_content('你要确定你是可以欣赏花的人类唷')
  end
end
