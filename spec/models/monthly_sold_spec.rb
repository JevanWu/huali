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
