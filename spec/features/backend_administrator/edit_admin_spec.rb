require 'feature_spec_helper'

feature "Edit administrator" do
  given(:super_admin) { create(:administrator, role: 'super') }

  given(:admin) { create(:administrator, email: 'admin1@example.com') }

  background do
    login_as(super_admin, scope: :administrator)
  end


  scenario "Validation errors" do
    visit "/admin/administrators/#{admin.id}/edit"

    fill_in '邮箱', with: ''
    fill_in '密码', with: 'aaa123'
    click_button '更新管理用户'

    find("#administrator_email_input").should have_content('您需要填写此项')
  end

  scenario "Edit successfully" do
    visit "/admin/administrators/#{admin.id}/edit"

    fill_in '邮箱', with: 'admin3@example.com'
    fill_in '密码', with: 'aaa123'
    click_button '更新管理用户'

    page.should have_content('admin3@example.com')
  end

  scenario "Set as super admin" do
    visit "/admin/administrators/#{admin.id}/edit"

    fill_in '邮箱', with: 'admin3@example.com'
    fill_in '密码', with: 'aaa123'
    select 'super', from: '角色'
    click_button '更新管理用户'

    logout(:administrator)
    login_as(admin.reload, scope: :administrator)

    visit '/admin'

    find('#header').should have_link('管理用户')
  end
end

