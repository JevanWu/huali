require 'spec_helper'

describe PeriodRegionPolicy do
  before do
    create(:period_region_policy, start_date: '2013-09-01', end_date: '2013-09-30')
    create(:period_region_policy, start_date: '2013-09-01', end_date: '2013-12-31')
  end

  describe "self.available_rules_at_date" do
    it "returns an array when no rules are found" do
      PeriodRegionPolicy.available_rules_at_date('2013-08-31').should == []
    end

    it "returns all the rules within the date period" do
      PeriodRegionPolicy.available_rules_at_date('2013-09-01').should have(2).items
      PeriodRegionPolicy.available_rules_at_date('2013-10-01').should have(1).items
    end
  end
end
