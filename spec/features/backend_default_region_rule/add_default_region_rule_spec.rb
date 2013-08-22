require 'spec_helper'

feature 'Add default region rule' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)

    import_region_data_from_files
  end

  scenario "Validation errors" do
    visit '/admin/default_region_rules/new'

    click_button '新增默认递送地域规则'

    page.should have_content('您需要填写此项')
  end

  scenario "Add successfully", js: true do
    visit '/admin/default_region_rules/new'

    fill_in '规则名称', with: '规则1'
    check_and_open_child('广东省')
    check_and_open_child('广州市')
    uncheck '天河区'
    close_region_popups

    click_button '新增默认递送地域规则'

    visit '/admin/products/new'
    page.find("#product_default_region_rule_id").should have_content('规则1')
  end
end

