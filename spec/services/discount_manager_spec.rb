require 'spec_helper'

describe 'DiscountManager' do

  describe "#apply_discount" do
    let(:order) do
      order = Object.new

      stub(order).new_record? { false }
      stub(order).changes { {} }
      stub(order).item_total { 200 }
      stub(order).coupon { nil }
      order
    end

    let(:coupon) { Object.new }

    context "when order has adjustment" do
      it "changes total of order with manual adjustment" do
        stub(order).adjustment { '*0.8' }
        mock(order).total = 160

        DiscountManager.new(order).apply_discount
      end
    end

    context "when order has no adjustment but has a coupon" do
      before(:each) do
        stub(order).adjustment { nil }
        stub(coupon).adjustment { "*0.9" }
        stub(order).coupon { coupon }

        mock(order).total = 180
      end

      it "changes total of order with the coupon" do
        DiscountManager.new(order).apply_discount
      end

      context "and order is new record" do
        it "uses coupon" do
          stub(order).new_record? { true }

          mock(coupon).use!

          DiscountManager.new(order).apply_discount
        end
      end

      context "and order's coupon is updated" do
        it "uses the new coupon" do
          stub(order).changes { { 'coupon_id' => [2,1] } }

          mock(coupon).use!

          DiscountManager.new(order).apply_discount
        end
      end
    end

    context "when order has no both adjustment and coupon" do
      it "do not change total of order" do
        stub(order).adjustment { nil }
        dont_allow(order).total = anything

        DiscountManager.new(order).apply_discount
      end
    end

  end
end
