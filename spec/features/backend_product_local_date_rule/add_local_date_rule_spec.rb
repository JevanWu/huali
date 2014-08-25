require 'feature_spec_helper'

feature "Add local date rule to product" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:user) }

  given(:product) {
    default_date_rule = create(:default_date_rule,
                               included_dates: '2013-09-01,2013-09-02',
                               excluded_dates: '2013-08-04,2013-08-05',
                               excluded_weekdays: ['6'])
    create(:product,
           name_zh: '红宝石',
           name_en: 'ruby',
           default_date_rule: default_date_rule)
  }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Added successfully", js: true do
    visit "/admin/products/#{product.slug}/edit"

    find('.add_date_rule').click
    fill_in '开始日期', with: '2013-07-01'
    fill_in '周期长度', with: '+2M'
    fill_in '包含日期', with: '2013-06-27,2013-06-28'
    fill_in '排除日期', with: '2013-07-04,2013-07-05'
    check 'Sunday'
    click_button '更新产品'

    login_as(user, scope: :user)

    visit "/products/#{product.slug}"
    click_link('放入购物车')

    within(".cart-checkout .checkout") do
      click_link('确定')
    end

    within("#new-order") do
      ['2013-07-01', '2013-06-27', '2013-06-28', '2013-09-01', '2013-09-02'].each do |date|
        fill_in '到达日期', with: date
        click_button '确定'
        page.should_not have_content('红宝石无法在该递送日期配送')
      end

      ['2013-08-04', '2013-08-05', '2013-07-04', '2013-07-05', '2013-08-10', '2013-08-11'].each do |date|
        fill_in '到达日期', with: date
        click_button '确定'
        page.should have_content('红宝石无法在该递送日期配送')
      end
    end
  end

  scenario "Validation error", js: true do
    visit "/admin/products/#{product.slug}/edit"

    find('.add_date_rule').click

    fill_in '周期长度', with: '+2M'
    fill_in '包含日期', with: '2013-06-27,2013-06-28'
    fill_in '排除日期', with: '2013-07-04,2013-07-05'
    check 'Sunday'
    click_button '更新产品'

    visit "/admin/products/#{product.slug}/edit"

    page.should_not have_content('开始日期')
    page.should_not have_content('周期长度')
    page.should_not have_content('包含日期')
    page.should_not have_content('排除日期')
  end
end
