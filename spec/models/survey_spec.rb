require 'spec_helper'

describe Survey do
  let(:survey) { create(:survey) }

  describe "#to_trait_tags" do
    it "returns the query string param for filtering product by trait tag" do
      survey.to_trait_tags.should == "female,girlfriend,nineteen_to_25,propose"
    end
  end
end
