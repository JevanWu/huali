require 'spec_helper'

feature "Edit page" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:single_page) { create(:page) }

  scenario "Edit successfully" do
    visit "/admin/pages/#{single_page.permalink}/edit"

    fill_in '英文标题', with: 'About'
    fill_in '中文标题', with: '关于我们'
    fill_in '英文内容', with: 'Huali...'
    fill_in '中文内容', with: '花里，源于一个简单而纯粹的愿望——从鲜花中得到美好。'
    uncheck '是否出现在页脚'

    click_button '更新单独页面'

    visit "/#{single_page.permalink}"

    page.should have_title('关于我们')
    page.should have_content('花里，源于一个简单而纯粹的愿望——从鲜花中得到美好。')
    page.should_not have_link('关于我们')
  end

  scenario "Set as displaying on page footer" do
    visit "/admin/pages/#{single_page.permalink}/edit"

    check '是否出现在页脚'
    click_button '更新单独页面'

    visit "/#{single_page.permalink}"

    page.should_not have_link('关于我们')
  end

  scenario "Edit with markdown" do
    visit "/admin/pages/#{single_page.permalink}/edit"

    fill_in '中文内容', with: '###花里花店的花很漂亮'
    click_button '更新单独页面'

    visit "/#{single_page.permalink}"

    page.html.should match(/<h3[^<>]+>花里花店的花很漂亮<\/h3>/)
  end
end

