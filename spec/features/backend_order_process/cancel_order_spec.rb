require 'feature_spec_helper'

feature "Cancel order" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "order is waiting for payment", js: true do
    order = create(:order)
    visit "/admin/orders/#{order.id}"

    click_link('取消')
    accept_confirm

    page.should have_content('订单状态变更为取消')
    find("#order_#{order.id}").should have_content('取消')
  end

  scenario "order is waiting for auditing", js: true do
    order = create(:order, :wait_check)
    visit "/admin/orders/#{order.id}"

    click_link('取消')
    accept_confirm

    page.should have_content('订单状态变更为取消')
    find("#order_#{order.id}").should have_content('等待退款')
  end

  scenario "order is waiting for making", js: true do
    order = create(:order, :wait_check, ship_method: ship_method).tap do |o|
      o.check
    end

    visit "/admin/orders/#{order.id}"

    click_link('取消')
    accept_confirm

    page.should have_content('订单状态变更为取消')
    find("#order_#{order.id}").should have_content('等待退款')
  end

  scenario "order is waiting for shipping", js: true do
    order = create(:order, :wait_check, ship_method: ship_method).tap do |o|
      o.check
      o.make
    end

    visit "/admin/orders/#{order.id}"

    click_link('取消')
    accept_confirm

    page.should have_content('订单状态变更为取消')
    find("#order_#{order.id}").should have_content('等待退款')
  end

  scenario "order was shipped", js: true do
    order = create(:order,
                   :wait_confirm,
                   :with_one_transaction,
                   :with_one_shipment)
    create(:shipment, order: order, state: :shipped)

    visit "/admin/orders/#{order.id}"

    click_link('取消')
    accept_confirm

    page.should have_content('订单状态变更为取消')
    find("#order_#{order.id}").should have_content('等待退款')
  end
end

