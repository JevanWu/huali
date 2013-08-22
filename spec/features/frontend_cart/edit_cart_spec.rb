require 'spec_helper'

feature 'Edit cart' do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario 'Change product quantity', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    find(".icon-plus").click

    page.should have_content(/¥\s*#{product.price * 2}/)

    find(".icon-minus").click

    page.should have_content(/¥\s*#{product.price}/)

    find(".icon-trash").click

    page.should_not have_link('红宝石')
  end
end

