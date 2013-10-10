require 'spec_helper'

feature "Place survey" do
  given(:product) { create(:product, name_en: 'ruby', name_zh: '红宝石', tag_list: 'lover') }

  background do
    # FIXME root page should always be setup up front
    Page.create!(title_en: "Home", title_zh: '首页', permalink: 'home')
  end

  scenario "Validation errors" do
    visit "/surveys/new"
    choose '男生'
    choose '他'
    click_button '帮我选花'

    find('.survey_gift_purpose').should have_content('您需要填写此项')
  end

  scenario "Added successfully" do
    visit "/surveys/new"
    choose '男生'
    choose '他'
    choose '爱人'
    click_button '帮我选花'

    page.should have_content('感谢您的填写，下面是为您挑选的商品')
  end
end
