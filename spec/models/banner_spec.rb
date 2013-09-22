require 'spec_helper'

describe Banner do
  describe ".fetch_by_date" do
    before do
      @banner = create(:banner)
    end

    subject { described_class.fetch_by_date("2013-09-19").to_a }

    it "returns the banners available in the date" do
      subject.should include(@banner)
    end
  end
end
