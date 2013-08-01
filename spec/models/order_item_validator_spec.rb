require 'spec_helper'

describe OrderItemValidator do

  let(:validator) { OrderItemValidator.new({}) }

  [:line_item1, :line_item2].each do |item_var|
    # let(:line_item1_errors) { Object.new }
    let("#{item_var}_errors".to_sym) { Object.new }
    # let(:line_item1) do ... end
    let(item_var) do
      Object.new.tap do |item|
        stub(item).errors { send("#{item_var}_errors") }
        stub(item).published { true }
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
    context "when there's not line item in the order" do
      it "add blank_products error to order" do
        stub(order).line_items { nil }

        mock(order_errors).add(:base, :blank_products)

        validator.validate(order)
      end
    end

    context "when all of the line items are valid" do
      it "do not add errors to order or the line items" do
        dont_allow(order_errors).add(:base, :unavailable_products)
        dont_allow(line_item1_errors).add(:product, :unavailable_product)
        dont_allow(line_item1_errors).add(:product, :invalid_quantity)
        dont_allow(line_item2_errors).add(:product, :unavailable_product)
        dont_allow(line_item2_errors).add(:product, :invalid_quantity)

        validator.validate(order)
      end
    end

    context "when one of the line items is not published" do
      it "add errors to order and the line item" do
        stub(line_item1).published { false }

        mock(order_errors).add(:base, :unavailable_products)
        mock(line_item1_errors).add(:product, :unavailable_product)

        validator.validate(order)
      end
    end

    context "when one of the line items's quantity is less than 1" do
      it "add errors to order and the line item" do
        stub(line_item2).quantity { 0 }

        mock(order_errors).add(:base, :unavailable_products)
        mock(line_item2_errors).add(:product, :invalid_quantity)

        validator.validate(order)
      end
    end
  end

end
