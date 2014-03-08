require 'spec_helper_lite'
require 'order_refund_service'

describe OrderRefundService do
  let(:order) do
    Object.new.tap do |o|
      stub(o).state { 'wait_refund' }
      stub(o).refund
    end
  end

  let(:refund) do
    Object.new.tap do |o|
      stub(o).state { 'pending' }
      stub(o).accept
      stub(o).reject
    end
  end

  describe ".accept_refund" do
    context "when the state of the refund is 'rejected'" do
      before do
        stub(refund).state { 'rejected' }
      end

      it "raise error" do
        lambda {
          described_class.accept_refund(order, refund)
        }.should raise_error(ArgumentError)
      end
    end

    context "when the state of the order is not 'wait_refund'" do
      before do
        stub(order).state { 'wait_make' }
      end

      it "raise error" do
        lambda {
          described_class.accept_refund(order, refund)
        }.should raise_error(ArgumentError)
      end
    end

    it "accept the refund" do
      mock(refund).accept

      described_class.accept_refund(order, refund)
    end

    it "set the state of the order to 'refunded'" do
      mock(order).refund

      described_class.accept_refund(order, refund)
    end
  end

  describe ".reject_refund" do
    before do
      stub(order).has_shipped_shipment? { true }
      stub(order).update_column
    end

    context "when the state of the order is not 'wait_refund'" do
      before do
        stub(order).state { 'wait_make' }
      end

      it "raise error" do
        lambda {
          described_class.reject_refund(order, refund)
        }.should raise_error(ArgumentError)
      end
    end

    it "reject the refund" do
      mock(refund).reject

      described_class.reject_refund(order, refund)
    end

    context "when the order had already been shipped" do
      it "set the state of the order back to 'wait_confirm'" do
        mock(order).update_column(:state, 'wait_confirm')

        described_class.reject_refund(order, refund)
      end
    end

    context "when the order has not been shipped yet" do
      before do
        stub(order).has_shipped_shipment? { false }
      end

      it "set the state of the order back to 'wait_ship'" do
        mock(order).update_column(:state, 'wait_ship')

        described_class.reject_refund(order, refund)
      end
    end
  end
end
