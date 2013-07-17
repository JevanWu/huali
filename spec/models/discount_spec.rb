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

end
