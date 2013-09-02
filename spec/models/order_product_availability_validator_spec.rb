require 'spec_helper_lite'
require 'active_model'
require 'order_product_availability_validator'

describe OrderProductAvailabilityValidator do

  let(:validator) do
    described_class.new({}).tap do |validator|
      stub(validator).fetch_product(line_item1) { product1 }
      stub(validator).fetch_product(line_item2) { product2 }
    end
  end

  [:product1, :product2].each do |pro_var|
    # let(:product1) do ... end
    let(pro_var) do
      Object.new.tap do |pro|
        stub(pro).id { pro_var.to_s.sub('product', '').to_i }
        stub(pro).count_on_hand { 100 }
        stub(pro).name { "#{pro}_name" }
        stub(pro).published { true }
      end
    end
  end

  [:line_item1, :line_item2].each do |item_var|
    # let(:line_item1_errors) { Object.new }
    let("#{item_var}_errors".to_sym) { Object.new }
    # let(:line_item1) do ... end
    let(item_var) do
      Object.new.tap do |item|
        stub(item).errors { send("#{item_var}_errors") }
        stub(item).quantity { 1 }
      end
    end
  end

  let(:order_errors) { Object.new }
  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
      stub(order).line_items { [line_item1, line_item2] }
    end
  end

  describe "#validate" do
    context "when all of the line items are valid" do
      it "do not add errors to order or the line items" do
        dont_allow(order_errors).add(:base, :unavailable_products)
        dont_allow(line_item1_errors).add(:base, :product_unavailable)
        dont_allow(line_item1_errors).add(:base, :product_out_of_stock)
        dont_allow(line_item2_errors).add(:product, :product_unavailable)
        dont_allow(line_item2_errors).add(:product, :product_out_of_stock)

        validator.validate(order)
      end
    end

    context "when one of the line items is not published" do
      it "add errors to order and the line item" do
        stub(product1).published { false }

        mock(order_errors).add(:base, :unavailable_products)
        mock(line_item1_errors).add(:base, :product_unavailable, product_name: product1.name)

        validator.validate(order)
      end
    end

    context "when one of the line items is out of stock" do
      it "add errors to order and the line item" do
        stub(product2).count_on_hand { 0 }

        mock(order_errors).add(:base, :unavailable_products)
        mock(line_item2_errors).add(:base, :product_out_of_stock, product_name: product2.name)

        validator.validate(order)
      end
    end
  end

end

