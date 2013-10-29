require 'spec_helper'

feature "Edit category" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    prepare_home_page
  end

  given(:category) { create(:collection, name_en: 'wedding', name_zh: '婚礼', display_name: '婚礼') }

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

  scenario "Set as available and top category" do
    visit "/admin/collections/#{category.slug}/edit"

    check '是否有效'
    select '', from: "父分类"
    click_button "更新品类"

    visit "/"
    page.should have_link("婚礼")
  end

  scenario "Set as not available" do
    visit "/admin/collections/#{category.slug}/edit"

    uncheck '是否有效'
    select '', from: "父分类"
    click_button "更新品类"

    visit "/"
    page.should_not have_link("婚礼")
  end

  scenario "Display name changed" do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "显示名称", with: '红色婚礼'
    click_button "更新品类"

    visit "/"
    page.should have_link("红色婚礼")
  end

  scenario "SEO changed", js: true do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "标题（SEO）", with: "SEO Title"
    fill_in "关键词", with: "SEO keywords"
    fill_in "关键描述", with: "SEO description"

    click_button "更新品类"

    visit "/collections/#{category.slug}"
    page.should have_title("SEO Title")
    page.find("meta[name='Keywords']", visible: false)["content"].should have_content("SEO keywords")
    page.find("meta[name='Description']", visible: false)["content"].should have_content("SEO description")
  end

  scenario "Set a parent" do
    create(:collection, name_en: 'love', name_zh: '爱情', display_name: '爱情')

    visit "/admin/collections/#{category.slug}/edit"

    select '爱情', from: '父分类'
    click_button "更新品类"

    page.should have_content(/父分类.*爱情/)
  end
end

