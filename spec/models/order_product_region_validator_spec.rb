require 'spec_helper'

describe OrderProductRegionValidator do

  let(:validator) { OrderProductRegionValidator.new({}) }
  let(:order_errors) { Object.new }
  let(:order_address) { Object.new }
  let(:order_address_errors) { Object.new }
  let(:p1_errors) { Object.new }
  let(:p2_errors) { Object.new }
  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
      stub(order).address { order_address }
    end
  end

  [:product1, :product2].each do |var|
    let(var) { stub!.name { var }.subject }
  end

  before(:each) do
    stub(product1).errors { p1_errors }
    stub(product2).errors { p2_errors }
    stub(order).fetch_products { [product1, product2] }

    stub(order_address).province { Object.new }
    stub(order_address).city { Object.new }
    stub(order_address).area { Object.new }
    stub(order_address).errors { order_address_errors }
  end

  describe "#validate" do
    before(:each) do
      stub(order).address_province_id { 1 }
      stub(order).address_city_id { 1 }
      stub(order).address_area_id { 1 }
    end

    context "when one of the products in order has no region rule" do
      it "raise error" do
        stub(product1).region_rule { nil }
        stub(product2).region_rule { Object.new }

        lambda {
          validator.validate(order)
        }.should raise_error
      end
    end

    context "order's address pass all of the product region rules" do
      it "do not add errors to order, order address and the product" do
        valid_rule1 = OpenStruct.new(
          province_ids: ['1'],
          city_ids: ['1'],
          area_ids: ['1'])

        valid_rule2 = OpenStruct.new(
          province_ids: ['1','2','3'],
          city_ids: ['1','2'],
          area_ids: ['1','2','3','4'])

        stub(product1).region_rule { valid_rule1 }
        stub(product2).region_rule { valid_rule2 }

        dont_allow(order_errors).add.with_any_args
        dont_allow(order_address_errors).add.with_any_args
        dont_allow(p1_errors).add.with_any_args
        dont_allow(p2_errors).add.with_any_args

        validator.validate(order)
      end
    end

    context "order's address can't pass one of the product region rules" do
      it "add errors to order, order address and the product" do
        valid_rule = OpenStruct.new(
          province_ids: ['1'],
          city_ids: ['1'],
          area_ids: ['1'])

        invalid_rule = OpenStruct.new(
          province_ids: ['1','2','3'],
          city_ids: ['1','2'],
          area_ids: ['2','3','4'])

        stub(product1).region_rule { valid_rule }
        stub(product2).region_rule { invalid_rule }

        mock(order_errors).add.with_any_args
        mock(order_address_errors).add.with_any_args.times(3)
        dont_allow(p1_errors).add.with_any_args
        mock(p2_errors).add.with_any_args

        validator.validate(order)
      end
    end
  end

end
