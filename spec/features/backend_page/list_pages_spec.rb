require 'spec_helper'

feature "List pages" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:page, title_zh: '关于我们')
    create(:page, title_zh: '配送信息')
  end

  scenario "List successfully" do
    visit '/admin/pages'

    page.should have_content('关于我们')
    page.should have_content('配送信息')
  end
end

