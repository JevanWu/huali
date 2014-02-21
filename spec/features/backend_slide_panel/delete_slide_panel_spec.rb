require 'spec_helper'

feature "Delete slide panel" do
  let(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    slide_panel = create(:slide_panel, name: 'hualigirls')
    visit "/admin/slide_panels"
    find("#slide_panel_#{slide_panel.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('hualigirls')
  end
end
