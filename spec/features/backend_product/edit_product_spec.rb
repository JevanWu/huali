require 'spec_helper'

feature "Edit product" do
  let(:admin) { create(:administrator) }

  given(:product) { create(:product, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
    create(:collection, display_name: '生日', name_en: 'birthday', name_zh: '生日')
  end

  scenario "Set as published", js: true do
    visit "/admin/products/#{product.slug}/edit"

    check '是否发布'
    click_button '更新产品'

    visit "/products/#{product.slug}"

    page.should have_content('红宝石')

    [:name, :original_price, :price, :height, :width, :depth, :description].each do |attr|
      page.should have_content(product.send(attr))
    end
  end

  scenario "Set a collection", js: true do
    visit "/admin/products/#{product.slug}/edit"

    check '是否发布'
    check '生日'
    click_button '更新产品'

    visit "/collections/birthday"

    page.should have_link('红宝石')
  end
end
