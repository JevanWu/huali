require 'spec_helper'

describe MailerHelper do

  describe "#find_product_count_from_collection" do
    let(:ruby) do
      Object.new.tap do |object|
        stub(object).product_count { 1 }
        stub(object).name_zh { 'ruby' }
      end
    end

    let(:provence) do
      Object.new.tap do |object|
        stub(object).product_count { 2 }
        stub(object).name_zh { 'provence' }
      end
    end

    let(:purple_dance) do
      Object.new.tap do |object|
        stub(object).product_count { nil }
        stub(object).name_zh { 'purple_dance' }
      end
    end

    let(:products_with_count) do
      [ruby, provence, purple_dance]
    end

    let(:products_with_count_by_date) do
      [
        { date: "2013-05-07".to_date, result: products_with_count },
        { date: "2013-05-08".to_date, result: products_with_count },
        { date: "2013-05-09".to_date, result: products_with_count }
      ]
    end

    context "when collection is a OrderProductsOnDateQuery collection" do
      context "when only collection was provided" do
        it "sums the product_count of the collection" do
          helper.find_product_count_from_collection(products_with_count).should eq(3)
        end
      end

      context "when both collection and name_zh were provided" do
        it "returns product_count of the product with the name" do
          helper.find_product_count_from_collection(products_with_count, 'ruby').should eq(1)
        end
      end
    end

    context "when collection is a Hash collection" do
      context "when only collection was provided" do
        it "does nothing and retunrs nil" do
          helper.find_product_count_from_collection(products_with_count_by_date).should be_nil
        end
      end

      context "when collection and date were provided" do
        it "returns the sum of the product_count of the collection of the date" do
          helper.find_product_count_from_collection(products_with_count_by_date, nil, '2013-05-07'.to_date).should eq(3)
        end
      end

      context "when collection, date and name were provided" do
        it "returns product_count of the one with the name in the collection of the date" do
          stub(provence).product_count { 5 }

          helper.find_product_count_from_collection(products_with_count_by_date, 'provence', '2013-05-08'.to_date).should eq(5)
        end
      end
    end
  end

end
