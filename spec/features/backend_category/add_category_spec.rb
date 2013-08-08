require 'spec_helper'

feature "Add category" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Validation errors" do
    visit "/admin/collections/new"
    fill_in "英文名", with: 'Birthday'
    fill_in "显示名称", with: '生日'
    click_button "创建品类"

    page.should have_content('中文名 您需要填写此项')
  end

  scenario "Added successfully" do
    visit "/admin/collections/new"
    fill_in "中文名", with: '生日'
    fill_in "英文名", with: 'Birthday'
    fill_in "显示名称", with: '生日'
    click_button "创建品类"

    page.should have_content('生日')
    page.should have_content('Birthday')
    page.should have_content('创建于')
  end
end

