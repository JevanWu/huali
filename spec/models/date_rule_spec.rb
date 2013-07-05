require 'spec_helper'

describe DateRule do
  describe "#merge" do
    let(:default_date_rule) { create(:default_date_rule) }
    let(:local_date_rule) { create(:local_date_rule) }

    context "with nil" do
      it "returns self" do
        default_date_rule.merge(nil).should == default_date_rule
      end
    end

    context "with other rule" do
      subject { default_date_rule.merge(local_date_rule) }

      it "returns new rule" do
        subject.should_not == default_date_rule
        subject.should_not == local_date_rule
      end

      it "overwrites start_date with other's" do
        subject.start_date.should == local_date_rule.start_date
      end

      it "overwrites end_date with other's" do
        subject.end_date.should == local_date_rule.end_date
      end

      it "union included_dates" do
        subject.included_dates.should == default_date_rule.included_dates | local_date_rule.included_dates
      end

      it "union excluded_dates" do
        subject.excluded_dates.should == default_date_rule.excluded_dates | local_date_rule.excluded_dates
      end

      it "union excluded_weekdays" do
        subject.excluded_weekdays.should == default_date_rule.excluded_weekdays | local_date_rule.excluded_weekdays
      end
    end
  end
end
