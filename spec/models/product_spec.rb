# == Schema Information
#
# Table name: products
#
#  count_on_hand                :integer          default(0), not null
#  created_at                   :datetime         not null
#  default_date_rule_id         :integer
#  default_region_rule_id       :integer
#  delivery                     :text
#  depth                        :decimal(8, 2)
#  description                  :text
#  discountable                 :boolean          default(TRUE)
#  flower_type                  :string(255)
#  height                       :decimal(8, 2)
#  id                           :integer          not null, primary key
#  inspiration                  :text
#  maintenance                  :text
#  material                     :text
#  meta_description             :string(255)
#  meta_keywords                :string(255)
#  meta_title                   :string(255)
#  name_en                      :string(255)      default(""), not null
#  name_zh                      :string(255)      default(""), not null
#  original_price               :decimal(, )
#  price                        :decimal(8, 2)
#  print_id                     :integer
#  priority                     :integer          default(5)
#  product_type                 :string(255)
#  promo_tag                    :string(255)
#  published                    :boolean          default(FALSE)
#  rectangle_image_content_type :string(255)
#  rectangle_image_file_name    :string(255)
#  rectangle_image_file_size    :integer
#  rectangle_image_updated_at   :datetime
#  sku_id                       :string(255)
#  slug                         :string(255)
#  sold_total                   :integer          default(0)
#  updated_at                   :datetime         not null
#  width                        :decimal(8, 2)
#
# Indexes
#
#  index_products_on_default_date_rule_id    (default_date_rule_id)
#  index_products_on_default_region_rule_id  (default_region_rule_id)
#  index_products_on_print_id                (print_id) UNIQUE
#  index_products_on_slug                    (slug) UNIQUE
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


  let(:product) { create(:product) }
  describe "#update_monthly_sold" do
    before do
      @monthly_sold = create(:monthly_sold, product: product)
    end

    context "updates the month sold of this month" do

      it "updates the sold_total of sold record of this month" do
        product.update_monthly_sold(10, Date.current)
        @monthly_sold.reload.sold_total.should == 110
      end

      it "updates the sold_total of the product at this month" do
        mock(product).update_column(:sold_total, @monthly_sold.sold_total + 10)
        product.update_monthly_sold(10, Date.current)
      end
    end

    context "updates the month sold of last month" do
      before do
        product.update_monthly_sold(10, -1.month.from_now.to_date)
      end

      it "updates the sold_total of sold record of last month" do
        @last_monthly_sold = product.month_sold(-1.month.from_now.to_date)
        @last_monthly_sold.sold_total.should == 10
        @monthly_sold.reload.sold_total.should == 100
      end

      it "does not updates the sold_total of the product at this month" do
        dont_allow(product).update_column(:sold_total, @monthly_sold.sold_total)
      end
    end
  end


  describe "#date_rule" do
    let(:product_with_local_rule) { create(:product, :with_local_rules) }

    it "date_rule equals to local_date_rule if it has local_date_rule" do
      product_with_local_rule.date_rule.should eq product_with_local_rule.local_date_rule
    end

    it "date_rule equals to default_date_rule if it has no local_date_rule" do
      product.date_rule.should eq product.default_date_rule
    end
  end

  describe "#update_stock" do
    let(:product) { create(:product, count_on_hand: 10) }

    it "update count_on_hand by substracting sold count" do
      mock(product).update_column(:count_on_hand, 0)

      product.update_stock(10)
    end
  end
end
