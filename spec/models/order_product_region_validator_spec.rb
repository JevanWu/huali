require 'spec_helper_lite'
require 'ostruct'
require 'active_model'
require 'order_product_validator_base'
require 'order_product_region_validator'

shared_examples_for "order region validator" do
  context "when one of the products in order has no region rule" do
    it "raise error" do
      stub(product1).region_rule { nil }

      lambda {
        validator.validate(order)
      }.should raise_error
    end
  end

  context "when order's address pass all of the product region rules" do
    it "do not add errors to order, order address and the product" do
      dont_allow(order_errors).add.with_any_args
      dont_allow(address_errors).add.with_any_args
      dont_allow(line_item1_errors).add.with_any_args
      dont_allow(line_item2_errors).add.with_any_args

      validator.validate(order)
    end
  end

  context "when order's address can't pass one of the product region rules" do
    it "add errors to order, order address and the product" do
      invalid_rule = valid_rule.dup
      invalid_rule.area_ids = ['2','3','4']

      stub(product2).region_rule { invalid_rule }

      mock(address_errors).add(:province_id, :unavailable_location)
      mock(address_errors).add(:city_id, :unavailable_location)
      mock(address_errors).add(:area_id, :unavailable_location)
      mock(order_errors).add(:base, :unavailable_location)

      dont_allow(line_item1_errors).add.with_any_args
      mock(line_item2_errors).add(:base, :product_in_unavailable_region, product_name: product2.name)

      validator.validate(order)
    end
  end
end

describe OrderProductRegionValidator do
  let(:valid_rule) do
    OpenStruct.new(
      province_ids: ['1','2','3'],
      city_ids: ['1','2'],
      area_ids: ['1','2','3','4'])
  end

  [:product1, :product2].each do |pro_var|
    # let(:product1) do ... end
    let(pro_var) do
      Object.new.tap do |pro|
        stub(pro).id { pro_var.to_s.sub('product', '').to_i }
        stub(pro).name { "#{pro_var}_name" }
        stub(pro).region_rule { valid_rule }
      end
    end
  end

  [:line_item1, :line_item2].each do |item_var|
    # let(:line_item1_errors) { Object.new }
    let(:"#{item_var}_errors") { Object.new }
    # let(:line_item1) do ... end
    let(item_var) do
      Object.new.tap do |item|
        stub(item).errors { send("#{item_var}_errors") }
        stub(item).product_id { item_var.to_s.sub('line_item', '').to_i }
        stub(item).quantity { 1 }
      end
    end
  end

  let(:order_errors) { Object.new }
  let(:address_errors) { Object.new }

  let(:address) do
    Object.new.tap do |addr|
      stub(addr).province_id { 1 }
      stub(addr).city_id { 1 }
      stub(addr).area_id { 1 }
      stub(addr).errors { address_errors }
    end
  end

  describe "with AR order has address and items as attributes" do
    it_behaves_like "order region validator" do
      let(:order) do
        Object.new.tap do |order|
          stub(order).errors { order_errors }
          stub(order).line_items { [line_item1, line_item2] }
          stub(order).address { address }
        end
      end

      let(:validator) do
        OrderProductRegionValidator.new.tap do |validator|
          stub(validator).fetch_product(line_item1) { product1 }
          stub(validator).fetch_product(line_item2) { product2 }
        end
      end
    end
  end
end
