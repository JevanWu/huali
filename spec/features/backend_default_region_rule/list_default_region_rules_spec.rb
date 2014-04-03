require 'feature_spec_helper'

feature "List default region rules" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:default_region_rule, name: '规则1')
    create(:default_region_rule, name: '规则2')
  end

  scenario "List successfully" do
    visit '/admin/default_region_rules'

    page.should have_content('规则1')
    page.should have_content('规则2')
  end
end
