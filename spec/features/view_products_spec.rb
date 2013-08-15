require 'spec_helper'

feature "View products" do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }
  given(:collection) { create(:collection, display_name: '生日') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
    product.collections << collection
  end

  scenario "by collection" do
    visit "/collections/#{collection.slug}"

    page.should have_link('红宝石')
  end
end

feature 'View product detail' do
  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario "on stock" do
    product = create(:product, name_en: 'ruby', name_zh: '红宝石')

    visit "/products/ruby"

    page.should have_content('红宝石')
    [:name, :original_price, :price, :height, :width, :depth, :description].each do |attr|
      page.should have_content(product.send(attr))
    end
    page.should have_content('放入购花篮')
  end

  scenario "out of stock" do
    product = create(:product, name_en: 'ruby', name_zh: '红宝石', count_on_hand: 0)

    visit "/products/ruby"

    page.should have_content('已经售罄')
  end
end
