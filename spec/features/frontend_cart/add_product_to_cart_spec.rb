require 'feature_spec_helper'

feature 'Add product to cart' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  background do
    prepare_home_page
  end

  scenario 'Added successfully', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购物车'

    page.should have_link('红宝石')
    page.should have_content(/¥\s*#{product.price}/)
    page.should have_content('1')
    find('.cart-checkout').should have_content(/小计.*?#{product.price}/)
  end
end
