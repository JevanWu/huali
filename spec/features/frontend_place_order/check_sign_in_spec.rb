require 'spec_helper'

feature "Check sign-in before placing order" do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario 'Guest user', js: true do
    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    click_link '确定'

    page.should have_content('继续操作前请注册或者登录')
  end

  given(:user) { create(:user) }

  scenario 'Logged user', js: true do
    login_as(user, scope: :user)

    visit "/products/#{product.slug}"

    click_link '放入购花篮'

    click_link '确定'

    page.should_not have_content('继续操作前请注册或者登录')
  end
end

