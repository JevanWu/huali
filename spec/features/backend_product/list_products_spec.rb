require 'feature_spec_helper'

feature "List products" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:product, name_zh: '红宝石')
    create(:product, name_zh: '紫舞')
  end

  scenario "List products successfully" do
    visit "/admin/products"

    page.should have_content('红宝石')
    page.should have_content('紫舞')
  end
end
