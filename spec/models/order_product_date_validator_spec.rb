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
    it "do not add errors to order or product" do
      dont_allow(order_errors).add.with_any_args
      dont_allow(product1_errors).add.with_any_args
      dont_allow(product2_errors).add.with_any_args

      validator.validate(order)
    end
  end

  context "when order's expected date can't pass one of the product date rules" do
    it "add errors to order and the product" do
      invalid_rule = valid_rule.dup
      invalid_rule.excluded_dates = ['2013-01-01']

      stub(product2).merged_date_rule { invalid_rule }

      mock(order_errors).add(:expected_date, :unavailable_date)
      dont_allow(product1_errors).add.with_any_args
      mock(product2_errors).add(:base, :product_in_unavailable_date, product_name: product2.name)

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
    # let(:product1_errors) { Object.new }
    let("#{pro_var}_errors".to_sym) { Object.new }
    # let(:product1) do ... end
    let(pro_var) do
      Object.new.tap do |pro|
        stub(pro).errors { send("#{pro_var}_errors") }
        stub(pro).default_date_rule { Object.new }
        stub(pro).merged_date_rule { valid_rule }
        stub(pro).name { "#{pro}_name" }
      end
    end
  end

  let(:order_errors) { Object.new }

  describe "with AR order has items as attributes" do
    it_behaves_like "order date validator" do
      let(:order) do
        Object.new.tap do |order|
          stub(order).errors { order_errors }
          stub(order).fetch_products { [product1, product2] }
          stub(order).expected_date { "2013-01-01".to_date }
        end
      end

      let(:validator) { OrderProductDateValidator.new() }
    end
  end
end

