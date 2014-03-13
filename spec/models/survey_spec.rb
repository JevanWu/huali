# == Schema Information
#
# Table name: surveys
#
#  created_at      :datetime         not null
#  gender          :string(255)
#  gift_purpose    :string(255)
#  id              :integer          not null, primary key
#  receiver_age    :string(255)
#  receiver_gender :string(255)
#  relationship    :string(255)
#  updated_at      :datetime         not null
#  user_id         :integer
#

require 'spec_helper'

describe Survey do
  let(:survey) { create(:survey) }

  describe "#to_trait_tags" do
    it "returns the query string param for filtering product by trait tag" do
      survey.to_trait_tags.should == "female,girlfriend,nineteen_to_25,propose"
    end
  end
end
