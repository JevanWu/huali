require 'spec_helper'

feature "Add page" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Validation errors" do
    visit "/admin/pages/new"

    fill_in '英文标题', with: 'About'
    fill_in '中文标题', with: '关于'
    fill_in '网址', with: ''
    check '是否出现在页脚'
    click_button '创建单独页面'

    page.find("#page_permalink_input").should have_content('您需要填写此项')
  end

  scenario "Added successfully" do
    visit "/admin/pages/new"

    fill_in '英文标题', with: 'About'
    fill_in '中文标题', with: '关于我们'
    fill_in '网址', with: 'about'
    fill_in '英文内容', with: 'Huali...'
    fill_in '中文内容', with: '花里，源于一个简单而纯粹的愿望——从鲜花中得到美好。'
    check '是否出现在页脚'
    click_button '创建单独页面'

    page.should have_content('关于我们')
    page.should have_content('about')

    visit '/about'
    page.should have_title("关于我们")
    page.should have_content('花里，源于一个简单而纯粹的愿望——从鲜花中得到美好。')
  end
end
