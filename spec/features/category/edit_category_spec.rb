require 'spec_helper'

feature "Edit category" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:category) { create(:collection, name_en: 'wedding', name_zh: '婚礼') }

  scenario "Validation errors" do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "中文名", with: ''
    fill_in "英文名", with: 'Birthday'
    fill_in "显示名称", with: '生日'
    click_button "更新品类"

    page.should have_content('中文名 您需要填写此项')
  end

  scenario "Edit successfully" do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "中文名", with: '生日'
    fill_in "英文名", with: 'Birthday'
    fill_in "显示名称", with: '生日'
    click_button "更新品类"

    page.should have_content('生日')
    page.should have_content('Birthday')
    page.should have_content('更新于')
  end
end

