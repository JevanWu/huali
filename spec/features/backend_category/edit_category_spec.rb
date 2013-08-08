require 'spec_helper'

feature "Edit category" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
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

  scenario "Set as available and primary" do
    visit "/admin/collections/#{category.slug}/edit"

    check '是否有效'
    check '主要分类'
    click_button "更新品类"

    visit "/"
    find("#product-nav").should have_content("婚礼")
  end

  scenario "Set as not available" do
    visit "/admin/collections/#{category.slug}/edit"

    uncheck '是否有效'
    check '主要分类'
    click_button "更新品类"

    visit "/"
    find("#product-nav").should_not have_content("婚礼")
  end

  scenario "Set as not primary" do
    visit "/admin/collections/#{category.slug}/edit"

    check '是否有效'
    uncheck '主要分类'
    click_button "更新品类"

    visit "/"
    find("#product-nav").should_not have_content("婚礼")
  end

  scenario "Display name changed" do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "显示名称", with: '红色婚礼'
    click_button "更新品类"

    visit "/"
    find("#product-nav").should have_content("红色婚礼")
  end

  scenario "SEO changed", js: true do
    visit "/admin/collections/#{category.slug}/edit"

    fill_in "标题（SEO）", with: '红色婚礼SEO'
    fill_in "关键词", with: '红色,婚礼'
    fill_in "关键描述", with: '红色的婚礼'

    click_button "更新品类"

    visit "/collections/#{category.slug}"
    page.should have_title("红色婚礼SEO")
    page.find("meta[name='keywords']", visible: false)["content"].should have_content("红色,婚礼")
    page.find("meta[name='description']", visible: false)["content"].should have_content("红色的婚礼")
  end
end

