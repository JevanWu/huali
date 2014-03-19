require 'feature_spec_helper'

feature "list slide panel" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:slide_panel, name: 'valentine', priority: 1)
    create(:slide_panel, name: 'hualigirls', priority: 2)
  end

  scenario "list all slides" do
    visit "/admin/slide_panels"

    page.should have_content('valentine')
    page.should have_content('hualigirls')
  end
end
