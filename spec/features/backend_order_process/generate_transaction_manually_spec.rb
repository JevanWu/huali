require 'spec_helper'

feature "Generate transaction manually for order" do
  let(:admin) { create(:administrator) }
  let(:ship_method) { create(:ship_method, name: 'USPS') }
  given(:order) { create(:order) }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Generate successfully", js: true do
    visit "/admin/orders/#{order.id}"
    click_link '生成交易'
    select '支付宝', from: '支付方式'
    select '支付宝', from: '商户名'
    fill_in '商户交易编号', with: 'xxx11110000'
    click_button '创建交易记录'

    click_link '开始'
    page.should have_content('交易状态变更为处理中')
    page.should have_content(/订单.*?#{order.identifier}/)
    click_link '完成'
    accept_confirm

    page.should have_content('交易状态变更为成功')
    page.should have_content(/订单.*?#{order.identifier}/)
    page.should have_content(/商户名.*?Alipay/)

    click_link("#{order.identifier}")
    page.should have_content(/订单状态.*?等待审核/)
  end

  scenario "Generate a failed transaction", js: true do
    visit "/admin/orders/#{order.id}"
    click_link '生成交易'
    select '支付宝', from: '支付方式'
    select '支付宝', from: '商户名'
    fill_in '商户交易编号', with: 'xxx11110000'
    click_button '创建交易记录'

    click_link '开始'
    page.should have_content('交易状态变更为处理中')
    page.should have_content(/订单.*?#{order.identifier}/)
    click_link '失败'
    accept_confirm

    page.should have_content('交易状态变更为失败')
    page.should have_content(/订单.*?#{order.identifier}/)
    page.should have_content(/商户名.*?Alipay/)

    click_link("#{order.identifier}")
    page.should have_content(/订单状态.*?等待付款/)
  end
end
