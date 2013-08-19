require 'spec_helper'

feature "Print order" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }
  given(:order) do
    o = create(:order,
               :wait_check,
               ship_method: ship_method,
               gift_card_text: '生日快乐')

    o.check
    o
  end

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Print order" do
    visit "/admin/orders/#{order.id}"

    page.should have_content('打印订单')
    page.should have_link('打印贺卡')
    page.should have_link('打印快递')
  end

  scenario "Print gift card" do
    visit "/admin/orders/#{order.id}/print_card"

    page.should have_content('抬头')
    page.should have_content('落款')
    page.should have_content('内容')
    page.should have_content('生日快乐')
  end
end

feature "Print shipment" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }
  given(:order) do
    o = create(:order, :wait_check, ship_method: ship_method)
    o.check
    o
  end

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Has no shipment yet", js: true do
    visit "/admin/orders/#{order.id}"
    click_link '打印快递'

    close_previous_window

    page.should have_content('货单未生成, 请先生成货单')
  end

  scenario "Has shipment", js: true do
    create(:shipment, order: order)

    visit "/admin/orders/#{order.id}"
    click_link '打印快递'

    close_previous_window

    page.should have_content(order.address.fullname)
    page.should have_content(order.address.phone)
    page.should have_content(order.address.print_addr)
    page.should have_content(order.address.post_code)
  end
end

