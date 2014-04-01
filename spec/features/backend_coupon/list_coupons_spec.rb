require 'feature_spec_helper'

feature "List coupons" do
  let(:admin) { create(:administrator) }

  background do
    login_as(admin, scope: :administrator)
    create(:coupon, note: 'coupon 1')
    create(:coupon, note: 'coupon 2')
  end

  scenario "List successfully" do
    visit '/admin/coupons'

    page.should have_content('coupon 1')
    page.should have_content('coupon 2')
  end
end
