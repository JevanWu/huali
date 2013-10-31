require 'spec_helper'

feature "Phone validation" do
  given(:user) { create(:user, email: 'user@hua.li', password: 'aaa123', password_confirmation: 'aaa123') }

  background do
    prepare_home_page

    login_as(user, scope: :user)
  end

  scenario "with a valid Chinese mobile phone" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '18621374266'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end

  scenario "with a valid Chinese fixed-line phone" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '010-65955379'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end

  scenario "with a invalid Chinese mobile phone" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '16611112222'
    click_button '更新'

    page.should have_content('联系方式 是无效的')
  end

  scenario "with a invalid Chinese fixed-line phone" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '010-659553790'
    click_button '更新'

    page.should have_content('联系方式 是无效的')
  end

  scenario "with a valid international mobile phone" do
    visit '/users/edit'


    select '+852(HK)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '6740 2312'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end

  scenario "with a valid international fixed-line phone" do
    visit '/users/edit'

    select '+41(CH)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '44 668 18 00'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end


  scenario "with a 400 phone" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '400-001-6936'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end

  scenario "sanitize before validation" do
    visit '/users/edit'

    select '+86(CN)', from: 'user_phone_calling_code'
    fill_in 'user_phone', with: '07013567933aaaa'
    click_button '更新'

    page.should_not have_content('联系方式 是无效的')
  end
end
