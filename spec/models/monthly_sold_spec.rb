# == Schema Information
#
# Table name: monthly_solds
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  product_id :integer
#  sold_month :integer
#  sold_total :integer          default(0)
#  sold_year  :integer
#  updated_at :datetime
#
# Indexes
#
#  index_monthly_solds_on_product_id                               (product_id)
#  index_monthly_solds_on_product_id_and_sold_year_and_sold_month  (product_id,sold_year,sold_month) UNIQUE
#

require 'spec_helper'

describe MonthlySold do
  let(:monthly_sold) { create(:monthly_sold) }

  describe "#update_sold_total" do
    it "increase the sold total by quantity provided" do
      monthly_sold.update_sold_total(5)

      monthly_sold.sold_total.should == 105
    end
  end
end
