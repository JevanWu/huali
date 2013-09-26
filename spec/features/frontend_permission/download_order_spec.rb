require 'spec_helper'

feature 'Permission to download order' do

  given(:admin) { create(:administrator) }
  given(:operation_manager) { create(:administrator, role: 'operation_manager') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
    create(:order)
  end

  scenario 'Login as operation manager', js: true do
    login_as(operation_manager, scope: :administrator)

    visit "/admin/orders/download_latest"

    page.should have_content("你没有访问该页面的权限")

    visit "/admin/orders/download_all"

    page.should have_content("你没有访问该页面的权限")
  end

  scenario 'Login as admin', js: true do
    login_as(admin, scope: :administrator)

    visit "/admin/orders/download_latest"

    page.should_not have_content("你没有访问该页面的权限")

    visit "/admin/orders/download_all"

    page.should_not have_content("你没有访问该页面的权限")
  end

end
