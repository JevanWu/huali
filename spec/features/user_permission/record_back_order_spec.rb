require 'feature_spec_helper'

feature 'Permission to record back order' do
  let(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  given(:operation_manager) { create(:administrator, role: 'operation_manager') }
  given(:product_manager) { create(:administrator, role: 'product_manager') }
  given(:marketing_manager) { create(:administrator, role: 'marketing_manager') }

  background do
    prepare_home_page
  end

  scenario 'Login as operation manager', js: true do
    login_as(operation_manager, scope: :administrator)

    visit "/products/#{product.slug}"

    click_link('放入购物车')

    page.should have_link('特殊订单')
    page.should have_link('渠道订单')

    visit "/orders/backorder"
    current_path.should == "/orders/backorder"

    visit "/orders/channelorder"
    current_path.should == "/orders/channelorder"
  end

  scenario 'Login as product manager', js: true do
    login_as(product_manager, scope: :administrator)

    visit "/products/#{product.slug}"

    click_link('放入购物车')

    page.should_not have_link('特殊订单')
    page.should_not have_link('渠道订单')

    visit "/orders/backorder"
    current_path.should_not == "/orders/backorder"
    page.should have_content("你没有访问该页面的权限")

    visit "/orders/channelorder"
    current_path.should_not == "/orders/channelorder"
    page.should have_content("你没有访问该页面的权限")
  end

  scenario 'Login as marketing manager', js: true do
    login_as(marketing_manager, scope: :administrator)

    visit "/products/#{product.slug}"

    click_link('放入购物车')

    page.should have_link('特殊订单')
    page.should have_link('渠道订单')

    visit "/orders/backorder"
    current_path.should == "/orders/backorder"

    visit "/orders/channelorder"
    current_path.should == "/orders/channelorder"
  end
end

