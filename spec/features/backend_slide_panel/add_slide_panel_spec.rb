require 'feature_spec_helper'

feature "Add slide panel" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  context "Priority Validation" do

    scenario "Priority is blank", js: true do
      visit "/admin/slide_panels/new"
      click_button '创建轮播设置'
      page.should have_content('优先级 您需要填写此项 和 不是数字')
    end
    
    scenario "Priority is a float number", js: true do
      visit "/admin/slide_panels/new"
      fill_in '优先级', with: 5.5
      click_button '创建轮播设置'
      page.should have_content('优先级 必须是整数')
    end

    scenario "The priority has been used", js: true do
      create (:slide_panel)
      visit "/admin/slide_panels/new"
      fill_in '优先级', with: 1
      click_button '创建轮播设置'

      page.should have_content('优先级 已经被使用') 
    end
  end

  scenario "Add slide panel successfully", js: true do
    visit "/admin/slide_panels/new"
    fill_in '名称', with: 'Valentine Day'
    fill_in '链接', with: '/'
    fill_in '优先级', with: 1
    attach_file('图片', File.join(Rails.root, 'spec', 'fixtures', 'hualigirls.jpg'))
    click_button '创建轮播设置'

    page.should have_content('轮播设置详情')
    page.should have_content(/名称.*Valentine Day/)
    page.should have_content(/链接.*\//)
    page.should have_content(/优先级.*1/)
  end

  scenario "Should not display slide if it is not visible", js: true do 
    prepare_home_page
    visit "/admin/slide_panels/new"
    fill_in '名称', with: 'Valentine Day'
    fill_in '链接', with: '/'
    fill_in '优先级', with: 1
    attach_file('图片', File.join(Rails.root, 'spec', 'fixtures', 'hualigirls.jpg'))
    click_button '创建轮播设置'

    visit root_path
    page.html.should_not match(/<img[^<>]*hualigirls\.jpg/)
  end
end
