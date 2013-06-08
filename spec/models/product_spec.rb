# == Schema Information
#
# Table name: products
#
#  count_on_hand    :integer          default(0), not null
#  created_at       :datetime         not null
#  depth            :decimal(8, 2)
#  description      :text
#  height           :decimal(8, 2)
#  id               :integer          not null, primary key
#  inspiration      :text
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  name_en          :string(255)      default(""), not null
#  name_zh          :string(255)      default(""), not null
#  original_price   :decimal(, )
#  price            :decimal(8, 2)
#  priority         :integer          default(5)
#  published        :boolean          default(FALSE)
#  slug             :string(255)
#  sold_total       :integer          default(0)
#  updated_at       :datetime         not null
#  width            :decimal(8, 2)
#
# Indexes
#
#  index_products_on_slug  (slug) UNIQUE
#

require 'spec_helper'
require 'set'

describe Product do
  describe "#suggestions" do
    before(:each) do
      @col1 = FactoryGirl.create(:collection)
      @col2 = FactoryGirl.create(:collection)

      @col1.products = FactoryGirl.create_list(:product, 10)
      @col2.products = FactoryGirl.create_list(:product, 10)

      @product = FactoryGirl.create(:product)
      @col1.products << @product

      @col1.save!
      @col2.save!

      @all_set = Set.new Product.all
      @col1_set = Set.new @col1.products
      @col2_set = Set.new @col1.products
    end

    after(:each) do
      Product.destroy_all
    end

    context "default - amount: 4, pool: all, type: random" do
      it "returns an Array of product_ids" do
        @product.suggestions.should be_a_kind_of Array

        selected_set = Set.new @product.suggestions

        selected_set.should be_subset(@all_set)
      end

      it "select ids according to the amount" do
        amount = Forgery(:basic).number
        @product.suggestions(amount).length.should == amount
      end

      it "selects ids randomly" do
        result1 = @product.suggestions(10).sort
        result2 = @product.suggestions(10).sort

        (result1 == result2).should be_false
      end
    end

    it "selects products from the products in the same collection" do

      selected_set = Set.new @product.suggestions(5, :collection)
      selected_set.should be_subset(@col1_set)
    end

    it "selects products by the order of priority" do
      expected = Product.order(:priority).limit(5).map(&:id)
      @product.suggestions(5, :all, :priority).map(&:id).should == expected
    end

    it "selects products by the order of sold_total amount" do
      expected = Product.order(:sold_total).limit(5).map(&:id)
      @product.suggestions(5, :all, :sold_total).map(&:id).should == expected
    end
  end
end
