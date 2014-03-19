require 'feature_spec_helper'

feature "Email list subscribing" do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }
  given(:collection) { create(:collection, display_name: '生日') }

  background do
    prepare_home_page
  end

  scenario "Valid email" do
    visit "/"

    fill_in "email", with: 'ryan@hua.li'
    click_button "发送"

    page.should have_content("订阅成功")
  end

  scenario "Invalid email" do
    visit "/"

    fill_in "email", with: 'a_invalid_email'
    click_button "发送"

    page.should have_content("无效的 Email, 订阅失败")
  end
end

