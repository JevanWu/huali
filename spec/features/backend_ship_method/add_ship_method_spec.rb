require 'spec_helper'

feature "Add ship method" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Validation errors" do
    visit "/admin/ship_methods/new"
    fill_in "名字", with: 'UPS'
    click_button "创建递送方式"

    page.find("#ship_method_method_input").should have_content('您需要填写此项')
  end

  scenario "Added successfully" do
    visit "/admin/ship_methods/new"
    fill_in "名字", with: 'UPS'
    choose "快递"
    click_button "创建递送方式"


    page.should have_content(/名字.*?UPS/)
    page.should have_content(/方式.*?Express/)

    visit '/admin/shipments/new'
    page.find("#shipment_ship_method_input").should have_content('UPS')
  end
end
