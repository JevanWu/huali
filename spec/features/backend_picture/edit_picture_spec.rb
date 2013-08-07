require 'spec_helper'

feature "Edit picture" do
  let(:admin) { create(:administrator, email: 'admin@example.com', password: 'adminx', password_confirmation: 'adminx') }

  background do
    login_as(admin, scope: :administrator)
  end

  given(:asset) { create(:asset) }

  scenario "Edit successfully", js: true do
    visit "/admin/assets/#{asset.id}/edit"
    attach_file('Image', File.join(Rails.root, 'spec', 'fixtures', 'sample.jpg'))
    click_button "更新图片"

    page.should have_content(/FILE NAME.*?sample\.jpg/)
  end
end


