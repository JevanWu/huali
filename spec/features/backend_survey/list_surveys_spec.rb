require 'spec_helper'

feature "List surveys" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:survey, gender: :male)
    create(:survey, gender: :female)
  end

  scenario "List successfully" do
    visit '/admin/surveys'

    page.find("#index_table_surveys").should have_content('male')
    page.find("#index_table_surveys").should have_content('female')
  end
end

