require 'spec_helper_lite'

require 'ostruct'
require 'active_model'
require 'order_product_region_validator'

describe OrderProductRegionValidator do

  let(:validator) { OrderProductRegionValidator.new({}) }

  let(:valid_rule) do
    OpenStruct.new(
      province_ids: ['1','2','3'],
      city_ids: ['1','2'],
      area_ids: ['1','2','3','4'])
  end

  [:product1, :product2].each do |pro_var|
    # let(:product1_errors) { Object.new }
    let("#{pro_var}_errors".to_sym) { Object.new }

    # let(:product1) do ... end
    let(pro_var) do
      Object.new.tap do |pro|
        stub(pro).name { "#{pro_var}_name" }
        stub(pro).errors { send("#{pro_var}_errors") } # product1_errors
        stub(pro).region_rule { valid_rule }
      end
    end
  end

  let(:order_errors) { Object.new }
  let(:order_address_errors) { Object.new }

  let(:order_address) do
    Object.new.tap do |addr|
      stub(addr).province { Object.new }
      stub(addr).city { Object.new }
      stub(addr).area { Object.new }
      stub(addr).errors { order_address_errors }
    end
  end

  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
      stub(order).address { order_address }

      stub(order).address_province_id { 1 }
      stub(order).address_city_id { 1 }
      stub(order).address_area_id { 1 }

      stub(order).fetch_products { [product1, product2] }
    end
  end

  describe "#validate" do
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
        dont_allow(order_address_errors).add.with_any_args
        dont_allow(product1_errors).add.with_any_args
        dont_allow(product2_errors).add.with_any_args

        validator.validate(order)
      end
    end

    context "when order's address can't pass one of the product region rules" do
      it "add errors to order, order address and the product" do
        invalid_rule = valid_rule.dup
        invalid_rule.area_ids = ['2','3','4']

        stub(product2).region_rule { invalid_rule }

        mock(order_address_errors).add(:province, :unavailable_location)
        mock(order_address_errors).add(:city, :unavailable_location)
        mock(order_address_errors).add(:area, :unavailable_location)
        mock(order_errors).add(:base, :unavailable_location)

        dont_allow(product1_errors).add.with_any_args
        mock(product2_errors).add(:base, :product_in_unavailable_region, product_name: product2.name)

        validator.validate(order)
      end
    end
  end

end
