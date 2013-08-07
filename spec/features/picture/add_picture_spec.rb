require 'spec_helper'

feature "Add picture" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "Added successfully", js: true do
    visit "/admin/assets/new"
    attach_file('Image', File.join(Rails.root, 'spec', 'fixtures', 'sample.jpg'))
    click_button "创建图片"

    page.should have_content(/FILE NAME.*?sample\.jpg/)
  end

  scenario "Validation errors" do
    visit "/admin/assets/new"
    click_button "创建图片"

    find("#asset_image_input").should have_content("您需要填写此项")
  end
end

