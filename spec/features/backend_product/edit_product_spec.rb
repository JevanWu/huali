require 'spec_helper'

feature "Edit product" do
  let(:admin) { create(:administrator) }

  given(:product) { create(:product, name_zh: '红宝石', name_en: 'ruby') }

  background do
    login_as(admin, scope: :administrator)
    create(:collection, display_name: '生日', name_en: 'birthday', name_zh: '生日')
  end

  scenario "Edit successfully" do
    visit "/admin/products/#{product.slug}/edit"

    fill_in "中文名", with: '红宝石mini'
    fill_in "英文名", with: 'rubymini'
    fill_in '产品灵感', with: '红宝石mini，象征热情似火、爱情的美好、永恒与坚贞。'
    fill_in '产品描述', with: '七夕精选-永生玫瑰，永生绣球，薰衣草mini。'

    fill_in '库存', with: 103
    fill_in '现价', with: 287
    click_button '更新产品'

    visit "/products/#{product.reload.slug}"

    [:name_zh, :original_price, :price, :height, :width, :depth, :description].each do |attr|
      page.should have_content(product.send(attr))
    end
  end

  scenario "Set as unpublished", js: true do
    visit "/admin/products/#{product.slug}/edit"

    uncheck '是否发布'
    click_button '更新产品'

    visit "/collections/birthday"

    page.should_not have_link('红宝石')
  end

  scenario "Set a collection", js: true do
    visit "/admin/products/#{product.slug}/edit"

    check '是否发布'
    check '生日'
    click_button '更新产品'

    visit "/collections/birthday"

    page.should have_link('红宝石')
  end

  scenario "Set recommendations", js: true do
    create(:product, name_zh: '海洋之心', name_en: 'Ocean heart')
    create(:product, name_zh: '紫舞', name_en: 'Purple dance')

    visit "/admin/products/#{product.slug}/edit"

    check '是否发布'
    check '海洋之心'
    check '紫舞'

    click_button '更新产品'

    visit "/products/#{product.slug}"

    page.should have_link('海洋之心')
    page.should have_link('紫舞')
  end

  scenario "Add new image", js: true do
    visit "/admin/products/#{product.slug}/edit"
    click_link '新增图片'
    attach_file('Upload Image', File.join(Rails.root, 'spec', 'fixtures', 'sample2.jpg'))
    click_button '更新产品'

    visit "/products/#{product.slug}"

    page.html.should match(/<img[^<>]*sample2\.jpg/)
  end

  scenario "Add rectangle image", js: true do
    visit "/admin/products/#{product.slug}/edit"
    attach_file('矩形图片', File.join(Rails.root, 'spec', 'fixtures', 'rectangle_image.jpg'))
    click_button '更新产品'

    page.html.should match(/<img[^<>]*rectangle_image\.jpg/)
  end

  scenario "Remove image", js: true do
    product.assets << create(:asset, image: Rails.root.join('spec/fixtures/sample2.jpg').open)

    visit "/admin/products/#{product.slug}/edit"

    find("img[alt~='Sample2'] ~ a").click
    accept_confirm

    click_button '更新产品'

    visit "/products/#{product.slug}"

    page.html.should_not match(/<img[^<>]*sample2\.jpg/)
  end
end
