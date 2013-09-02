require 'spec_helper'

feature "Audit order" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }

  background do
    login_as(admin, scope: :administrator)
    ship_method
  end

  scenario "Lack of information", js: true do
    o = create(:order, :wait_check, delivery_date: nil)

    visit "/admin/orders/#{o.id}"
    click_link '审核'
    accept_confirm

    within("form.order_admin_form") do
      fill_in '发货日期', with: "#{o.expected_date - 1}"
      find('#order_admin_form_sender_name').click # for closing date-picker popup
      choose 'USPS'
      choose 'Facebook'
      click_button('更新订单', match: :first)
    end

    click_link '审核'
    accept_confirm

    page.should have_content('订单状态变更为等待制作')
  end

  scenario "Complete information", js: true do
    o = create(:order, :wait_check, ship_method: ship_method)

    visit "/admin/orders/#{o.id}"
    click_link '审核'
    accept_confirm

    page.should have_content('订单状态变更为等待制作')
  end
end
