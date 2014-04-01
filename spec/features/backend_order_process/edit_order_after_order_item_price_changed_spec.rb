require 'feature_spec_helper'

feature "Edit order after order item price changed" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Audited", js: true do
    order =create(:order, :wait_check, ship_method: ship_method).tap do |o|
      o.check
    end

    old_total = order.total

    product = order.products.first
    product.update_attribute(:price, product.price + 10)

    visit "/admin/orders/#{order.id}/edit"

    within("form.order_admin_form") do
      fill_in '收件人地址', with: '新地址'
      click_button('更新订单', match: :first)
    end

    page.should have_content(old_total)
  end

  scenario "Not yet audited", js: true do
    order =create(:order, :wait_check, ship_method: ship_method)

    old_total = order.total

    line_item = order.line_items.first
    line_item.product.update_attribute(:price, line_item.product.price + 10)

    visit "/admin/orders/#{order.id}/edit"

    within("form.order_admin_form") do
      fill_in '收件人地址', with: '新地址'
      click_button('更新订单', match: :first)
    end

    page.should have_content(old_total + 10 * line_item.quantity)
  end
end

