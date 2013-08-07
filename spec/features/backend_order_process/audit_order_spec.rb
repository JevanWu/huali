require 'spec_helper'

feature "Audit order" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }
  let(:ship_method) { create(:ship_method, name: 'USPS') }

  background do
    login_as(admin, scope: :administrator)
    ship_method
  end

  scenario "Lack of information", js: true do
    o = create(:order, :wait_check, delivery_date: nil)

    visit "/admin/orders/#{o.id}"
    click_link '审核'
    page.driver.browser.switch_to.alert.accept

    within("form.order") do
      fill_in '发货日期', with: "#{o.expected_date - 1}"
      choose 'USPS'
      choose 'Facebook'
      click_button('更新订单', match: :first)
    end

    click_link '审核'
    page.driver.browser.switch_to.alert.accept

    page.should have_content('订单状态变更为等待制作')
  end

  scenario "Complete information", js: true do
    o = create(:order, :wait_check, ship_method: ship_method)

    visit "/admin/orders/#{o.id}"
    click_link '审核'
    page.driver.browser.switch_to.alert.accept

    page.should have_content('订单状态变更为等待制作')
  end
end
