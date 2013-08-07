require 'spec_helper'

feature "Show category" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:category) { create(:collection, name_en: 'Wedding', name_zh: '婚礼') }

  scenario "Show successfully" do
    visit "/admin/collections/#{category.slug}"

    page.should have_content('婚礼')
    page.should have_content('Wedding')
  end
end
