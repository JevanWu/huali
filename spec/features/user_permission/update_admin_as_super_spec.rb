require 'feature_spec_helper'

feature "Edit super administrator" do
  given(:super_admin) { create(:administrator, role: 'super') }

  given(:admin) { create(:administrator, email: 'admin1@example.com') }

  before do
    prepare_home_page
  end

  scenario "Logged as a admin", js: true do
    login_as(admin, scope: :administrator)

    visit "/admin/administrators/#{admin.id}/edit"

    find("#administrator_role").should_not have_content("super")

    page.execute_script %($("#administrator_role").prepend("<option value='super'>super</option>"))
    select "super", from: "角色"
    fill_in "邮箱", with: 'superadmin@hua.li'
    fill_in "密码", with: 'superadmin'

    click_button "更新管理用户"

    page.should have_content("继续操作前请注册或者登录.")
  end

  scenario "Logged as a super admin" do
    login_as(super_admin, scope: :administrator)

    visit "/admin/administrators/#{admin.id}/edit"

    find("#administrator_role").should have_content("super")

    fill_in "邮箱", with: 'superadmin@hua.li'
    fill_in "密码", with: 'superadmin'
    select 'super', from: "角色"

    click_button "更新管理用户"

    page.should_not have_content("访问受限")
    page.should have_content(/邮箱.*superadmin@hua.li/)
    page.should have_content(/角色.*super/)
  end
end
