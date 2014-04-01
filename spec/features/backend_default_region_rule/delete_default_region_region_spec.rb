require 'feature_spec_helper'

feature "Delete default date rule" do
  given(:super_admin) { create(:administrator, role: 'super') }

  background do
    login_as(super_admin, scope: :administrator)
  end

  scenario "Delete successfully", js: true do
    default_region_rule = create(:default_region_rule, name: '规则1')

    visit "/admin/default_region_rules"
    find("#default_region_rule_#{default_region_rule.id}").click_link("删除")
    accept_confirm

    page.should_not have_content('规则1')
  end
end

