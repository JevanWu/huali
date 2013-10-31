require 'spec_helper'

feature "Check placed order" do
  let(:admin) { create(:administrator) }

  scenario "Check sucessfully" do
    o = create(:order)

    login_as(admin, scope: :administrator)

    visit '/admin/orders'

    find("#index_table_orders").find('tbody').first('td a').click

    page.should have_content(/订单状态.*等待付款/)
    page.should have_content(/类型.*普通订单/)
    page.should have_content(/订单编号.*OR.*\d+/)
    page.should have_content(/订单内容.*x\s*\d+/)
    page.should have_content('到达日期')
    page.should have_content('发货日期')
    page.should have_content('递送方式')
    page.should have_content('收货人信息')
    page.should have_content('收货人姓名')
    page.should have_content('收货人电话')
    page.should have_content('卡片信息')
    page.should have_content('特殊要求')
    page.should have_content("物品总价")
    page.should have_content("价格调整")
    page.should have_content("订单总价")
    page.should have_content("来源")
    page.should have_content("寄件人姓名")
    page.should have_content("寄件人邮箱")
    page.should have_content("寄件人电话")

    page.should have_content(/¥\s*.+/)
  end
end
