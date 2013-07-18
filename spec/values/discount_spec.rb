require 'spec_helper'

describe Discount do

  describe "#calculate" do
    context "when adjustment is '+10'" do
      it "returns a new amount of the amount to discount plusing 10" do
        discount = Discount.new("+10")

        discount.calculate(10).should eq(20)
      end
    end

    context "when adjustment is '-10'" do
      it "returns a new amount of the amount to discount subtracting 10" do
        discount = Discount.new("-10")

        discount.calculate(10).should eq(0)
      end
    end

    context "when adjustment is '*10'" do
      it "returns a new amount of multiplying the amount to discount by 10" do
        discount = Discount.new("*10")
        discount.calculate(10).should eq(100)
      end
    end

    context "when adjustment is 'x10'" do
      it "returns a new amount of multiplying the amount to discount by 10" do
        discount = Discount.new("x10")
        discount.calculate(10).should eq(100)
      end
    end

    context "when adjustment is '%10'" do
      it "returns a new amount of the amount to discount divided by 10" do
        discount = Discount.new("%10")
        discount.calculate(10).should eq(1)
      end
    end

    context "when adjustment is '/10'" do
      it "returns a new amount of the amount to discount divided by 10" do
        discount = Discount.new("/10")
        discount.calculate(10).should eq(1)
      end
    end
  end

  # FIXME: weird dependency on child class
  describe ".generate" do
    context "with manaul adjustment" do
      it "return a ManualDiscount instance" do
        discount = Discount.generate("*0.9", nil)

        discount.should be_a(ManualDiscount)
      end
    end

    context "with a Coupon" do
      it "return a CouponDiscount instance" do
        coupon = Coupon.new
        stub(coupon).adjustment { '*0.9' }

        discount = Discount.generate("", coupon)

        discount.should be_a(CouponDiscount)
      end
    end

    context "without both adjustment and coupon_code" do
      it "return a NullDiscount instance" do
        discount = Discount.generate(nil, nil)

        discount.should be_a(NullDiscount)
      end
    end
  end
end

describe CouponDiscount do
  describe "#initialize" do
    it "return a coupon discount" do
      coupon = Coupon.new
      mock(coupon).adjustment { '*0.9' }

      discount = CouponDiscount.new(coupon)
    end
  end
end

describe NullDiscount do
  describe "#calculate" do
    it "returns the original amount without discount" do
      discount = NullDiscount.new

      discount.calculate(299).should eq(299)
    end
  end
end
