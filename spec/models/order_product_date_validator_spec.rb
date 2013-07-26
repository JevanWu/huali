require 'spec_helper'

describe OrderProductDateValidator do

  let(:validator) { OrderProductDateValidator.new({}) }
  let(:order_errors) { Object.new }
  let(:p1_errors) { Object.new }
  let(:p2_errors) { Object.new }
  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
    end
  end

  [:product1, :product2].each do |var|
    let(var) { stub!.name { var }.subject }
  end

  before(:each) do
    stub(product1).errors { p1_errors }
    stub(product2).errors { p2_errors }
    stub(order).fetch_products { [product1, product2] }
  end

  describe "#validate" do
    before(:each) do
      stub(order).expected_date { "2013-01-01".to_date }
      stub(product1).default_date_rule { Object.new }
      stub(product2).default_date_rule { Object.new }
    end

    context "when one of the products in order has no default date rule" do
      it "raise error" do
        stub(product1).default_date_rule { nil }
        stub(product2).default_date_rule { Object.new }

        lambda {
          validator.validate(order)
        }.should raise_error
      end
    end

    context "order's expected date pass all of the product date rules" do
      it "do not add errors to order or product" do
        valid_rule1 =  OpenStruct.new(
            start_date: "2013-01-01",
            end_date: "2013-12-01",
            included_dates: [],
            excluded_dates: [],
            excluded_weekdays: [])

        valid_rule2 =  OpenStruct.new(
            start_date: "2013-02-01",
            end_date: "2013-12-01",
            included_dates: ["2013-01-01"],
            excluded_dates: [],
            excluded_weekdays: [])

        stub(product1).merged_date_rule { valid_rule1 }
        stub(product2).merged_date_rule { valid_rule2 }

        dont_allow(order_errors).add.with_any_args
        dont_allow(p1_errors).add.with_any_args
        dont_allow(p2_errors).add.with_any_args

        validator.validate(order)
      end
    end

    context "order's expected date can't pass one of the product date rules" do
      it "add errors to order and the product" do
        valid_rule =  OpenStruct.new(
            start_date: "2013-01-01",
            end_date: "2013-12-01",
            included_dates: [],
            excluded_dates: [],
            excluded_weekdays: [])

        invalid_rule =  OpenStruct.new(
            start_date: "2013-01-01",
            end_date: "2013-12-01",
            included_dates: [],
            excluded_dates: ["2013-01-01"],
            excluded_weekdays: [])

        stub(product1).merged_date_rule { valid_rule }
        stub(product2).merged_date_rule { invalid_rule }

        mock(order_errors).add.with_any_args
        dont_allow(p1_errors).add.with_any_args
        mock(p2_errors).add.with_any_args

        validator.validate(order)
      end
    end
  end

end
