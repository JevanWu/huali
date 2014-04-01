require 'feature_spec_helper'

feature "List categories" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)

    @love = create(:collection, name_zh: '爱情', display_name: '爱情')
    @confess = create(:collection, name_zh: '表白', display_name: '表白', parent: @love)
    @wedding = create(:collection, name_zh: '婚礼', display_name: '婚礼', parent: @confess)
  end

  scenario "List categories by hierarchy" do
    visit "/admin/collections"

    find("#collection_#{@love.id}").should have_content("爱情")
    find("#collection_#{@love.id} > ol > li").should have_content("表白")
    find("#collection_#{@love.id} > ol > li > ol").should have_content("婚礼")
  end
end
