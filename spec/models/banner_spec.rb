# == Schema Information
#
# Table name: banners
#
#  content    :string(255)
#  created_at :datetime
#  end_date   :date
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :date
#  updated_at :datetime
#

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
