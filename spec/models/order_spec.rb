# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code          :string(255)
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :string(255)
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  type                 :string(255)      default("normal"), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#  index_orders_on_user_id     (user_id)
#

require 'spec_helper'

describe Order do

  describe "#update_sold_total" do
    let(:order) { FactoryGirl.create(:order, :wait_confirm) }

    it 'is called after order state changes to complete' do
      order.should_receive(:update_sold_total).once
      order.confirm
    end

    it 'increments the products quantity by the line items quantity' do
      former_quantities = order.line_items.map(&:sold_total)
      increment_amounts = order.line_items.map(&:quantity)

      order.send(:update_sold_total)

      result_quantities = order.line_items.map(&:sold_total)

      former_quantities.each_with_index do |amount, i|
        (former_quantities[i] + increment_amounts[i]).should == result_quantities[i]
      end
    end
  end

  describe OrderProductDateValidator do
    context "when expected_date valid" do
      let(:order) { FactoryGirl.create(:order, expected_date: "2013-01-01".to_date) }

      subject { order }

      it { should be_valid }
    end

    context "when expected_date invalid " do
      let(:order) { FactoryGirl.create(:order, expected_date: "2012-12-01".to_date) }

      before(:each) do
        order.products.reload.map(&:date_rule)
        order.valid?
      end

      subject { order }

      it { should_not be_valid }
      it "has unavailable_date error" do
        subject.errors[:base].should include(:unavailable_date)
      end
    end

    context "merge local rule with global rule" do
      let(:order) { FactoryGirl.create(:order, expected_date: "2013-01-01".to_date) }

      before(:each) do
        order.products.reload.map(&:date_rule)
      end

      it "override start dates and end dates" do
        order.expected_date = "2013-02-01"
        order.should be_valid

        order.expected_date = "2013-12-01"
        order.should_not be_valid
      end

      it "union included dates" do
        order.expected_date = "2013-02-02"
        order.should be_valid

        order.expected_date = "2013-02-05"
        order.should be_valid
      end

      it "union excluded_dates" do
        order.expected_date = "2013-01-02"
        order.should_not be_valid

        order.expected_date = "2013-01-05"
        order.should_not be_valid
      end

      it "union excluded_weekdays" do
        order.expected_date = "2013-01-13"
        order.should_not be_valid

        order.expected_date = "2013-01-19"
        order.should_not be_valid
      end
    end
  end

  describe OrderProductRegionValidator do
    before(:each) do
      order.line_items.each do |line|
        line.product.local_date_rule = nil
      end
    end

    context "when region invalid" do
      let(:order) { FactoryGirl.create(:order, expected_date: "2013-02-05".to_date) }

      before(:each) do
        order.products.reload
        order.address = create(:address)

        # Differ region rule address from order
        new_addr = create(:address)
        order.line_items.reload.each do |line|
          line.product.local_region_rule = build(:local_region_rule,
                                           province_ids: [new_addr.province_id.to_s],
                                           city_ids: [new_addr.city_id.to_s],
                                           area_ids: [new_addr.area_id.to_s],
                                           product: line.product)
        end

        order.valid?
      end

      subject { order }

      it { should_not be_valid }

      it "has unavailable_location error" do
        subject.errors[:base].should include(:unavailable_location)
      end
    end

    context "when region valid" do
      let(:order) { FactoryGirl.create(:order, expected_date: "2013-02-05".to_date) }

      before(:each) do
        order.products.reload
        address = create(:address)
        order.address = address

        order.line_items.reload.each do |line|
          line.product.local_region_rule = build(:local_region_rule,
                                           province_ids: [address.province_id.to_s],
                                           city_ids: [address.city_id.to_s],
                                           area_ids: [address.area_id.to_s],
                                           product: line.product)
        end
      end

      subject { order }

      it { should be_valid }
    end
  end
end
