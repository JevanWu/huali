require 'spec_helper'

feature 'List default date rules' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:default_date_rule, name: '时间规则1', start_date: "2013-01-01")
    create(:default_date_rule, name: '时间规则2', start_date: "2013-08-01")
  end

  scenario "List successfully" do
    visit '/admin/default_date_rules'

    page.should have_content('时间规则1')
    page.should have_content('时间规则2')
    page.should have_content('2013年1月01日')
    page.should have_content('2013年8月01日')
  end
end
