require 'spec_helper'

feature 'Permission to update seo of collections' do
  let(:collection) { create(:collection, name_en: 'birthday') }

  given(:operation_manager) { create(:administrator, role: 'operation_manager') }
  given(:product_manager) { create(:administrator, role: 'product_manager') }
  given(:web_operation_manager) { create(:administrator, role: 'web_operation_manager') }

  background do
    prepare_home_page
  end

  scenario 'Login as operation manager', js: true do
    login_as(operation_manager, scope: :administrator)

    visit "/admin/collections/#{collection.id}/edit"

    page.should_not have_content("SEO")
  end

  scenario 'Login as product manager', js: true do
    login_as(product_manager, scope: :administrator)

    visit "/admin/collections/#{collection.id}/edit"

    page.should_not have_content("SEO")
  end

  scenario 'Login as web operation manager', js: true do
    login_as(web_operation_manager, scope: :administrator)

    visit "/admin/collections/#{collection.id}/edit"

    page.should have_content("SEO")

    fill_in "标题（SEO）", with: 'SEO-Title'
    fill_in "关键词", with: 'SEO-Keywords'
    fill_in "关键描述", with: 'SEO-Description'

    click_button '更新品类'

    page.should have_content('SEO-Title')
    page.should have_content('SEO-Keywords')
    page.should have_content('SEO-Description')
  end
end

feature 'Permission to update seo of products' do
  let(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  given(:operation_manager) { create(:administrator, role: 'operation_manager') }
  given(:product_manager) { create(:administrator, role: 'product_manager') }
  given(:web_operation_manager) { create(:administrator, role: 'web_operation_manager') }

  background do
    prepare_home_page
  end

  scenario 'Login as operation manager', js: true do
    login_as(operation_manager, scope: :administrator)

    visit "/admin/products/#{product.id}/edit"

    page.should_not have_content("SEO")
  end

  scenario 'Login as product manager', js: true do
    login_as(product_manager, scope: :administrator)

    visit "/admin/products/#{product.id}/edit"

    page.should_not have_content("SEO")
  end

  scenario 'Login as web operation manager', js: true do
    login_as(web_operation_manager, scope: :administrator)

    visit "/admin/products/#{product.id}/edit"

    page.should have_content("SEO")

    fill_in "标题（SEO）", with: 'SEO-Title'
    fill_in "关键词", with: 'SEO-Keywords'
    fill_in "关键描述", with: 'SEO-Description'

    click_button '更新产品'

    visit "/products/#{product.id}"
    page.html.should match(/SEO-Title/)
    page.html.should match(/SEO-Keywords/)
    page.html.should match(/SEO-Description/)
  end
end

