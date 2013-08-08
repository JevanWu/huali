require 'spec_helper'

feature 'List ship methods' do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:ship_method, name: 'UPS')
    create(:ship_method, name: 'USPS')
  end

  scenario "List successfully" do
    visit '/admin/ship_methods'

    page.should have_content('UPS')
    page.should have_content('USPS')
  end
end
