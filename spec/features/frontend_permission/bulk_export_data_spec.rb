require 'spec_helper'

feature 'Permission to bulk export data' do

  given(:admin) { create(:administrator) }
  given(:operation_manager) { create(:administrator, role: 'operation_manager') }

  background do
    prepare_home_page
    create(:order)
  end

  scenario 'Login as operation manager', js: true do
    login_as(operation_manager, scope: :administrator)

    visit "/admin/orders.json"

    page.should have_content("你没有访问该页面的权限")

    visit "/admin/orders.xml"

    page.should have_content("你没有访问该页面的权限")
  end

  scenario 'Login as admin', js: true do
    login_as(admin, scope: :administrator)

    visit "/admin/orders.json"

    page.should_not have_content("你没有访问该页面的权限")

    visit "/admin/orders.xml"

    page.html.should_not match("你没有访问该页面的权限")
  end

end
