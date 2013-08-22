require 'spec_helper'

feature "View orders" do
  given(:user) { create(:user) }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
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

    click_link @order1.identifier

    page.should have_content(@order1.identifier)
    page.should have_content(@order1.address.fullname)
    page.should have_content(@order1.address.print_addr)
    page.should have_content(@order1.address.phone)
    page.should have_content(@order1.total)
  end
end

