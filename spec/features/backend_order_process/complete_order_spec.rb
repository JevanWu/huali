require 'spec_helper'

feature "Complete order" do
  let(:admin) { create(:administrator) }

  given(:order) do
    o = create(:order,
               :wait_confirm,
               :with_one_transaction,
               :with_one_shipment)
    create(:shipment, order: o, state: :shipped)
    o
  end

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Complete successfully", js: true do
    visit "/admin/orders/#{order.id}"

    click_link('确认')
    page.driver.browser.switch_to.alert.accept

    page.should have_content('递送状态变更为已经送达')
    find("#shipment_#{order.shipment.id}").should have_content('已经送达')
  end
end
