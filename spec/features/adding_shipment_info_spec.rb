require_relative '../spec_helper'

feature "Adding shipment info to order" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }
  let(:ship_method) { create(:ship_method, name: 'USPS') }
  given(:order) do
    create(:order, :wait_check, ship_method: ship_method).tap do |o|
      o.check
    end
  end

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "No shipment info yet" do
    visit "/admin/orders/#{order.id}"
    click_link('添加货运记录')
    fill_in '快递单号', with: 'xxooxxooxxooxxo'
    choose 'USPS'
    fill_in '备注', with: '一些备注'
    click_button '创建货运记录'

    page.should have_content(/订单.*#{order.identifier}/)
    page.should have_content(/快递单号.*xxooxxooxxooxxo/)
    page.should have_content(/递送方式.*USPS/)
    page.should have_content(/备注.*一些备注/)
  end

  scenario "Shipment info has been added already" do
    create(:shipment, order: order, ship_method: ship_method)

    visit "/admin/orders/#{order.id}"
    click_link('添加货运记录')

    fill_in '快递单号', with: 'xxooxxooxxooxxo'
    fill_in '备注', with: '一些备注'
    click_button '更新货运记录'

    page.should have_content(/订单.*#{order.identifier}/)
    page.should have_content(/快递单号.*xxooxxooxxooxxo/)
    page.should have_content(/递送方式.*USPS/)
    page.should have_content(/备注.*一些备注/)
  end
end
