# == Schema Information
#
# Table name: shipments
#
#  address_id           :integer
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  kuaidi100_result     :text
#  kuaidi100_status     :string(255)
#  kuaidi100_updated_at :datetime
#  note                 :text
#  order_id             :integer
#  ship_method_id       :integer
#  state                :string(255)
#  tracking_num         :string(255)
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_shipments_on_identifier      (identifier)
#  index_shipments_on_order_id        (order_id)
#  index_shipments_on_ship_method_id  (ship_method_id)
#  index_shipments_on_tracking_num    (tracking_num)
#

require 'spec_helper'

describe "#kuaidi100_poll" do
  it 'is called after shipment state changes to shipped' do
    shipment = FactoryGirl.create(:shipment)
    shipment.should_receive(:kuaidi100_poll).once
    shipment.ship
  end

  describe '#sync_with_kuaidi100_status' do
    before(:each) do
      @shipment = FactoryGirl.create(:shipment)
      @shipment.ship
    end

    it 'syncs with unknown' do
      @shipment.kuaidi100_status = 2
      @shipment.send(:sync_with_kuaidi100_status)

      @shipment.state.should == 'unknown'
    end

    it 'syncs with confirmed' do
      @shipment.kuaidi100_status = 3
      @shipment.send(:sync_with_kuaidi100_status)

      @shipment.state.should == 'completed'
    end
  end
end
