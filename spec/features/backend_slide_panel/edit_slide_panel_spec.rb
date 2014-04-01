require 'feature_spec_helper'

feature "Edit slide panel" do
  let(:admin) { create(:administrator) }
  let(:slide_panel) { create(:slide_panel, name: 'hualigirls')}

  background do
    prepare_home_page

    login_as(admin, scope: :administrator)
  end

  scenario "Edit successfully", js: true do
    visit "/admin/slide_panels/#{slide_panel.id}/edit"

    fill_in '名称', with: '花里'
    fill_in '优先级', with: 5
    click_button '更新轮播设置'

    visit "/admin/slide_panels/#{slide_panel.id}"
    page.should have_content(/名称.*花里/)
    page.should have_content(/优先级.*5/)
  end

  scenario "Set to visile", js: true do
    visit "/admin/slide_panels/#{slide_panel.id}/edit"
    attach_file('图片', File.join(Rails.root, 'spec', 'fixtures', 'hualigirls.jpg'))
    check '首页是否可见'
    click_button '更新轮播设置'

    visit root_path
    page.html.should match(/<img[^<>]*hualigirls\.jpg/)
  end
end

