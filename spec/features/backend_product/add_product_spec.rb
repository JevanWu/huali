require 'feature_spec_helper'

feature "Add product" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:collection, name_zh: '生日', display_name: '生日')
    create(:default_date_rule)
    create(:default_region_rule)
  end

  scenario "Validation errors", js: true do
    visit "/admin/products/new"
    fill_in "英文名", with: 'ruby'
    check '生日'
    fill_in '产品灵感', with: '红宝石，象征热情似火、爱情的美好、永恒与坚贞。'
    fill_in '产品描述', with: '七夕精选--永生玫瑰，永生绣球，薰衣草。'

    fill_in '库存', with: 10
    fill_in '现价', with: 299

    click_button '创建产品'

    page.should have_content('中文名 您需要填写此项')
  end

  scenario "Added successfully", js: true do
    visit "/admin/products/new"
    fill_in "中文名", with: '红宝石'
    fill_in "英文名", with: 'ruby'
    check '生日'
    fill_in '产品灵感', with: '红宝石，象征热情似火、爱情的美好、永恒与坚贞。'
    fill_in '产品描述', with: '七夕精选--永生玫瑰，永生绣球，薰衣草。'

    click_link '新增图片'
    attach_file('Upload Image', File.join(Rails.root, 'spec', 'fixtures', 'sample.jpg'))
    attach_file('矩形图片', File.join(Rails.root, 'spec', 'fixtures', 'rectangle_image.jpg'))
    fill_in '库存', with: 10
    fill_in '现价', with: 299

    click_button '创建产品'

    page.should have_content('产品详情')
    page.should have_content(/中文名.*红宝石/)
    page.should have_content(/英文名.*ruby/)
    page.should have_content(/产品灵感.*红宝石，象征热情似火、爱情的美好、永恒与坚贞。/)
    page.should have_content(/产品描述.*七夕精选.*永生玫瑰，永生绣球，薰衣草/)
    page.should have_content(/品类.*生日/)
    page.should have_content(/库存.*10/)
  end
end


