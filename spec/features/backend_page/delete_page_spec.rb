require 'feature_spec_helper'

feature "Delete page" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    single_page = create(:page, title_zh: '关于我们')

    visit "/admin/pages"
    find("#page_#{single_page.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('关于我们')
  end
end


