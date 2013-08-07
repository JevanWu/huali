require 'spec_helper'

feature "Ship order" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }
  let(:ship_method) { create(:ship_method, name: 'USPS') }
  given(:order) do
    create(:order, :wait_check, ship_method: ship_method).tap do |o|
      o.check
      o.make
    end
  end

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Produce order with freight records", js: true do
    create(:shipment, order: order, ship_method: ship_method)

    visit "/admin/orders/#{order.id}"
    click_link('发货')
    click_link('发货')
    page.driver.browser.switch_to.alert.accept

    page.should have_content('递送状态变更为已发货')
  end

  scenario "Produce order without freight records", js: true do
    visit "/admin/orders/#{order.id}"
    click_link('发货')

    fill_in '快递单号', with: 'xxooxxooxxooxxo'
    choose 'USPS'
    fill_in '备注', with: '一些备注'
    click_button '创建货运记录'

    click_link('发货')
    page.driver.browser.switch_to.alert.accept

    page.should have_content('递送状态变更为已发货')
  end
end
