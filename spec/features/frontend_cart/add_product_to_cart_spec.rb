require 'spec_helper'

feature 'Add product to cart' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario 'Added successfully', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    page.should have_link('红宝石')
    page.should have_content(/¥\s*#{product.price}/)
    page.should have_content('1')
    find('#cart-content').find('tfoot').should have_content(/总计.*?#{product.price}/)
  end
end
