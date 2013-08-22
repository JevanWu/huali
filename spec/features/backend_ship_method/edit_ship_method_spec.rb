require 'spec_helper'

feature "Edit ship method" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:ship_method) { create(:ship_method) }

  scenario "Validation errors" do
    visit "/admin/ship_methods/#{ship_method.id}/edit"
    fill_in "名字", with: ''
    click_button "更新递送方式"

    page.should have_content('名字 您需要填写此项')
    page.find("#ship_method_name_input").should have_content('您需要填写此项')
  end

  scenario "Edit successfully" do
    visit "/admin/ship_methods/#{ship_method.id}/edit"
    fill_in "名字", with: 'UPS'
    choose "快递"
    click_button "更新递送方式"


    page.should have_content(/名字.*?UPS/)
    page.should have_content(/方式.*?Express/)

    visit '/admin/shipments/new'
    page.find("#shipment_ship_method_input").should have_content('UPS')
  end
end

