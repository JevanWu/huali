require 'spec_helper'

feature 'Edit cart' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石', price: '188') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario 'Change product quantity', js: true do
    visit "/products/#{product.slug}"
    page.execute_script("$.removeCookie('cart');") # Ensure cart is empty before run spec

    click_link '放入购花篮'

    find(".add_quantity").click

    page.should have_content(/¥\s*376/)

    find(".reduce_quantity").click

    page.should have_content(/¥\s*188/)

    find(".empty_quantity").click

    page.should_not have_link('红宝石')
  end
end

