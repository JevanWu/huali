require 'feature_spec_helper'

feature "Notification banner" do

  background do
    prepare_home_page
    create(:banner, content: 'Test Notification', start_date: Date.current, end_date: 7.days.since.to_date)
  end

  scenario "Display banner successfully", js: true do
    visit "/"

    page.should have_content("Test Notification")
  end

  scenario "Close a notification banner", js: true do
    visit "/"

    find("#banner .close").click

    page.should_not have_content("Test Notification")

    visit "/"

    page.should_not have_content("Test Notification")
  end

  scenario "Display next banner notification in next page reflash after close one", js: true do
    create(:banner, content: 'Next Test Notification', start_date: Date.current, end_date: 7.days.since.to_date)

    visit "/"

    find("#banner .close").click

    visit "/"

    page.should have_content("Next Test Notification")
  end

end


