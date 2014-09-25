# == Schema Information
#
# Table name: collections
#
#  available             :boolean          default(FALSE)
#  created_at            :datetime         not null
#  description           :string(255)
#  display_name          :string(255)
#  display_on_breadcrumb :boolean          default(FALSE)
#  id                    :integer          not null, primary key
#  meta_description      :string(255)
#  meta_keywords         :string(255)
#  meta_title            :string(255)
#  name_en               :string(255)      not null
#  name_zh               :string(255)      not null
#  parent_id             :integer
#  primary_category      :boolean          default(FALSE), not null
#  priority              :integer          default(5)
#  slug                  :string(255)
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_collections_on_slug  (slug) UNIQUE
#

require 'spec_helper'

describe Collection do
  let(:collection) { create(:collection, name_zh: '生日快乐', display_name: '生日') }

  describe "#show_name" do
    context "when collection has display_name" do
      specify { collection.show_name.should == '生日' }
    end

    context "when collection has no display_name" do
      before do
        collection.display_name = nil
      end

      specify { collection.show_name.should == '生日快乐' }
    end
  end

  describe "#to_s" do
    specify { collection.to_s.should == "#{collection.id} 生日快乐" }
  end

  describe ".parents_options" do
    before do
      @love = create(:collection, name_zh: '爱情', display_name: '爱情')
      @confess = create(:collection, name_zh: '表白', display_name: '表白', parent: @love)
      @wedding = create(:collection, name_zh: '婚礼', display_name: '婚礼', parent: @confess)
    end

    it "returns a array of category with indented names and id" do
      [["爱情", @love.id], ["#{'&nbsp;' * 3}表白", @confess.id], ["#{'&nbsp;' * 6}婚礼", @wedding.id]].each do |item|
        Collection.parents_options(collection.id).should include(item)
      end
    end
  end
end
