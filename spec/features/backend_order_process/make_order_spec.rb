require 'spec_helper'

feature "Make order" do
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

  scenario "Make successfully", js: true do
    visit "/admin/orders/#{order.id}"
    click_link '制作'
    page.driver.browser.switch_to.alert.accept

    page.should have_content('订单状态变更为等待发货')
  end
end
