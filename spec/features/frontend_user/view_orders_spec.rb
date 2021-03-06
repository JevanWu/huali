require 'feature_spec_helper'

feature "View orders" do
  given(:user) { create(:user) }

  background do
    prepare_home_page
    @order1 = create(:order, user: user)
    @order2 = create(:order, user: user)

    login_as(user, scope: :user)
  end

  scenario "List orders placed" do
    visit '/orders'

    page.should have_content(@order1.identifier)
    page.should have_content(@order2.identifier)
  end

  scenario "View order detail" do
    visit '/orders'

    click_link('查看订单详情', match: :first)

    page.should have_content(@order2.identifier)
    page.should have_content(@order2.address.fullname)
    page.should have_content(@order2.address.print_addr)
    page.should have_content(@order2.address.phone)
    page.should have_content(@order2.total)
  end
end

