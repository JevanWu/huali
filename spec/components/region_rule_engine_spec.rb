require 'spec_helper'

describe RegionRuleEngine do
  describe '#apply_test' do
    before(:each) do
      @province_ids = [1,2,3,4]
      @city_ids = [1,2,3,4,5,6,7]
      @area_ids = [1,2,4,4,5,6,7,8,9,10,11,12]
    end

    let(:region_rule_engine) { RegionRuleEngine.new(@province_ids, @city_ids, @area_ids) }

    context "when area_id is not nil" do
      it "it test with area_id" do
        region_rule_engine.apply_test(1, 1, 1).should be_true
        region_rule_engine.apply_test(1, 1, 13).should be_false
      end
    end

    context "when area_id is nil" do
      it "it test with city_id" do
        region_rule_engine.apply_test(1, 1, nil).should be_true
        region_rule_engine.apply_test(1, 9, nil).should be_false
      end
    end
  end
end
