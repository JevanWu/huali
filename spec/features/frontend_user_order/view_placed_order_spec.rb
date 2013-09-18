require 'spec_helper'

feature "View placed order" do
  given(:user) { create(:user, email: 'user@hua.li', password: 'aaa123', password_confirmation: 'aaa123') }

  given(:order) do
    o = create(:order,
               :wait_confirm,
               :with_one_transaction,
               :with_one_shipment,
               user: user)
    o
  end

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')

    # Test kuaidi_100 results
    order.shipment.update_attribute(:kuaidi100_result,
                          %([{"context":"上海:已送达","time":"2013-01-31 10:19:24","ftime":"2013-01-31 10:19:24"},{"context":"上海:货件已装车，派送途中","time":"2013-01-31 09:14:53","ftime":"2013-01-31 09:14:53"},{"context":"上海:位于当地的联邦快递递送站","time":"2013-01-31 08:57:03","ftime":"2013-01-31 08:57:03"},{"context":"上海:已取件","time":"2013-01-30 16:57:24","ftime":"2013-01-30 16:57:24"},{"context":"上海:已取件","time":"2013-01-30 16:57:06","ftime":"2013-01-30 16:57:06"}]))

    login_as(user, scope: :user)
  end

  scenario "Order was shipped" do
    visit "/orders/#{order.id}"

    page.should have_content('配送记录')
    page.should have_content("发货日期：#{I18n.l order.delivery_date}")
  end
end

