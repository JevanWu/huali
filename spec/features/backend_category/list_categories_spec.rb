require 'spec_helper'

feature "List categories" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:collection, name_zh: '生日')
    create(:collection, name_zh: '表白')
  end

  scenario "List categories successfully" do
    visit "/admin/collections"

    page.should have_content('生日')
    page.should have_content('表白')
  end
end
