require 'spec_helper'

describe Cart do
  let(:product_1) { create(:product, name_zh: '红宝石', name_en: 'ruby', price: 200) }
  let(:cart_item_1) { LineItem.new(product_id: product_1.id, quantity: 1) }

  let(:product_2) { create(:product, name_zh: '海洋之心', name_en: 'heart_of_ocean', price: 259) }
  let(:cart_item_2) { LineItem.new(product_id: product_2.id, quantity: 2) }

  let(:coupon_code_record) { create(:coupon, adjustment: '*0.8').coupon_codes.first }
  let(:coupon_code) { coupon_code_record.code }
  let(:cart) { Cart.new([cart_item_1, cart_item_2], coupon_code) }

  describe "#initialize" do
    context "with coupon code" do
      context "that is usable" do
        it "set adjustment with the adjustment in the coupon code" do
          cart.adjustment.should eq("*0.8")
        end
      end

      context "that is not usable" do
        let(:coupon_code_record) { create(:coupon, expired: true, adjustment: '*0.8').coupon_codes.first }

        it "do not set adjustment with the adjustment in the coupon code" do
          cart.adjustment.should be_nil
        end
      end
    end

    context "with manual adjustment" do
      let(:cart) { Cart.new([cart_item_1, cart_item_2], nil, "*0.7") }

      it "set adjustment with the provided adjustment" do
        cart.adjustment.should eq("*0.7")
      end
    end
  end

  describe "#original_total" do
    it "returns total price of all the products to buy" do
      cart.original_total.should eq(200 * 1 + 259 * 2)
    end
  end

  describe "#item_count" do
    it "returns item count of all the products" do
      cart.item_count.should eq(1 + 2)
    end
  end

  describe "#valid_coupon?" do
    subject { cart.valid_coupon? }

    context "when the coupon code is valid?" do
      it { should be_true }
    end

    context "when the coupon code is not valid?" do
      let(:coupon_code) { '0101abcd' }

      it { should be_false }
    end
  end

  describe "#total" do
    context "when having applied coupon" do
      it "returns discounted total price of all the products to buy" do
        cart.total.should eq((200 * 1 + 259 * 2) * 0.8)
      end
    end

    context "when not having applied coupon" do
      let(:coupon_code) { nil }
      it "returns total price of all the products to buy" do
        cart.total.should eq(200 * 1 + 259 * 2)
      end
    end
  end

  describe "#discounted?" do
    subject { cart.discounted? }

    context "when having applied coupon" do
      it { should be_true }
    end

    context "when not having applied coupon" do
      let(:coupon_code) { nil }
      it { should be_false }
    end
  end

  describe "#discount_money" do
    it "return the price cut after applying coupon" do
      cart.discount_money.should == (200 * 1 + 259 * 2) - ((200 * 1 + 259 * 2) * 0.8)
    end
  end

  describe "#discount_rate" do
    it "return the rate of price cut after applying coupon" do
      cart.discount_rate.should == 0.8
    end
  end
end
