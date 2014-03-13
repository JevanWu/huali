require 'spec_helper'

feature "Edit transaction" do
  let(:admin) { create(:administrator) }

  given(:uncompleted_transaction) { create(:transaction, state: 'generated') }
  given(:completed_transaction) { create(:transaction, state: 'completed') }

  background do
    login_as(admin, scope: :administrator)
  end

  scenario "completed transaction cannot be edited", js: true do
    visit "/admin/transactions/#{completed_transaction.id}/edit"
    page.should have_content("交易已结束，不能编辑")
  end

  scenario "uncompleted transaction can be edited", js: true do
    visit "/admin/transactions/#{uncompleted_transaction.id}/edit"
    page.should have_content("编辑交易记录")
  end
end
