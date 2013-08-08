require 'spec_helper'

feature "Delete category" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    category = create(:collection, name_en: 'wedding', name_zh: '婚礼', display_name: '婚礼')

    visit "/admin/collections"
    find("#collection_#{category.id}").click_link("删除")
    page.driver.browser.switch_to.alert.accept

    page.should_not have_content('婚礼')
    page.should_not have_content('wedding')
  end
end
