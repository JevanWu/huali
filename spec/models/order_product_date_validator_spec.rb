require 'spec_helper_lite'
require 'active_support/core_ext/string/conversions.rb'
require 'ostruct'
require 'active_model'
require 'order_product_date_validator'

shared_examples_for "order date validator" do
  context "when one of the products in order has no default date rule" do
    it "raise error" do
      stub(product1).default_date_rule { nil }

      lambda {
        validator.validate(order)
      }.should raise_error
    end
  end

  context "when order's expected date pass all of the product date rules" do
    it "do not add errors to order or line item" do
      dont_allow(order_errors).add.with_any_args
      dont_allow(line_item1_errors).add.with_any_args
      dont_allow(line_item2_errors).add.with_any_args

      validator.validate(order)
    end
  end

  context "when order's expected date can't pass one of the product date rules" do
    it "add errors to order and the line item" do
      invalid_rule = valid_rule.dup
      invalid_rule.excluded_dates = ['2013-01-01']

      stub(product2).date_rule { invalid_rule }

      mock(order_errors).add(:expected_date, :unavailable_date)
      dont_allow(line_item1_errors).add.with_any_args
      mock(line_item2_errors).add(:base, :product_in_unavailable_date, product_name: product2.name)

      validator.validate(order)
    end
  end
end

describe OrderProductDateValidator do


  let(:valid_rule) {
    OpenStruct.new(start_date: "2013-01-01",
                   end_date: "2013-12-01",
                   included_dates: [],
                   excluded_dates: [],
                   excluded_weekdays: [])
  }

  [:product1, :product2].each do |pro_var|
    # let(:product1) do ... end
    let(pro_var) do
      Object.new.tap do |pro|
        stub(pro).id { pro_var.to_s.sub('product', '').to_i }
        stub(pro).default_date_rule { Object.new }
        stub(pro).date_rule { valid_rule }
        stub(pro).name { "#{pro}_name" }
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

  describe "with AR order has items as attributes" do
    it_behaves_like "order date validator" do
      let(:order) do
        Object.new.tap do |order|
          stub(order).errors { order_errors }
          stub(order).line_items { [line_item1, line_item2] }
          stub(order).expected_date { "2013-01-01".to_date }
        end
      end

      let(:validator) do
        OrderProductDateValidator.new.tap do |validator|
          stub(validator).fetch_product(line_item1) { product1 }
          stub(validator).fetch_product(line_item2) { product2 }
        end
      end
    end
  end
end

