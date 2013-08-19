require 'spec_helper'

feature 'Add default date rule' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Validation errors" do
    visit '/admin/default_date_rules/new'

    fill_in '开始日期', with: '2013-08-01'
    fill_in '周期长度', with: '+2M'
    fill_in '包含日期', with: '2013-07-19,2013-07-20'
    fill_in '排除日期', with: '2013-12-01,2013-12-02'
    check 'Monday'

    click_button '新增默认递送时间规则'

    page.find("#default_date_rule_name_input").should have_content('您需要填写此项')
  end

  scenario "Add successfully" do
    visit '/admin/default_date_rules/new'

    fill_in '开始日期', with: '2013-08-01'
    fill_in '周期长度', with: '+2M'
    fill_in '包含日期', with: '2013-07-19,2013-07-20'
    fill_in '排除日期', with: '2013-12-01,2013-12-02'
    check 'Monday'
    fill_in '规则名称', with: '规则1'

    click_button '新增默认递送时间规则'

    page.should have_content(/开始日期.*?2013年8月01日/)
    page.should have_content(/包含日期.*?2013-07-19.*?2013-07-20/)
    page.should have_content(/排除日期.*?2013-12-01.*?2013-12-02/)
    page.should have_content(/排除星期.*?1/)
    page.should have_content(/规则名称.*?规则1/)
    page.should have_content(/周期长度.*?\+2M/)


    visit '/admin/products/new'
    page.find("#product_default_date_rule_id").should have_content('规则1')
  end
end
