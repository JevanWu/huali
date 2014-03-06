require 'spec_helper'

describe API::API do
  include ApiHelpers

  before do
    import_region_data_from_files
  end

  let(:province) { create(:province) }
  let(:city) { province.cities.first }
  let(:area) { city.areas.first }
  let(:product) { create(:product) }

  let!(:valid_order) do
    {
      sender_name: 'Bob',
      sender_email: 'bob@test.com',
      sender_phone: '18621374266',
      coupon_code: nil,
      gift_card_text: nil,
      special_instructions: nil,
      kind: 'taobao',
      merchant_order_no: '499769390881821',
      ship_method_id: nil,
      expected_date: nil,
      delivery_date: nil,
      address_fullname: 'Jen Barbar',
      address_phone: '18622223333',
      address_province_id: province.id,
      address_city_id: city.id,
      address_area_id: area.id,
      address_post_code: area.post_code,
      address_address: 'some address'
    }
  end

  let!(:unvalid_order) do
    {
      sender_name: 'Bob',
      sender_email: 'bob@test.com',
      sender_phone: '18621374266',
      coupon_code: nil,
      gift_card_text: nil,
      special_instructions: nil,
      merchant_order_no: '499769390881821',
      ship_method_id: nil,
      expected_date: nil,
      delivery_date: nil,
      address_fullname: 'Jen Barbar',
      address_phone: '18622223333',
      address_province_id: province.id,
      address_city_id: city.id,
      address_area_id: area.id,
      address_post_code: area.post_code,
      address_address: 'some address'
    }
  end

  describe "POST /orders" do
    context "with valid order parameters" do
      it "should create order" do
        post api("/orders"), valid_order
        response.status.should == 201
      end
    end

    context "when not providing required parameters" do
      it "should return 400 bad request error" do
        post api("/orders"), unvalid_order
        response.status.should == 400
      end
    end

    context "when some parameters are not valid" do
      let!(:unvalid_order) do
        {
          sender_name: 'Bob',
          sender_email: 'bob@test.com',
          sender_phone: '18621374266',
          coupon_code: nil,
          gift_card_text: nil,
          special_instructions: nil,
          merchant_order_no: '499769390881821',
          ship_method_id: nil,
          expected_date: nil,
          delivery_date: nil,
          address_fullname: 'Jen Barbar',
          address_phone: '18622223333',
          address_province_id: province.id,
          address_city_id: city.id,
          address_area_id: area.id,
          address_post_code: area.post_code,
          address_address: 'some address'
        }
      end

      it "should return 400 bad request error" do
        post api("/orders"), unvalid_order
        response.status.should == 400
        response.body.should match("kind")
      end
    end
  end

  let(:order) { create(:third_party_order, :without_line_items) }

  describe "POST /orders/:kind/:id/line_items" do
    let(:product) { create(:product) }
    let(:order_kind) { 'taobao' }
    let(:invalid_params) { { price: 299, quantity: 2 } }
    let(:valid_params) { { product_id: product.id , price: 299, quantity: 2 } }

    context "when the id of the order kind not found" do
      it "returns 404 not found error" do
        post api("/orders/#{order_kind}/8829/line_items"), valid_params

        response.status.should == 404
      end
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        post api("/orders/#{order_kind}/#{order.merchant_order_no}/line_items"), invalid_params

        response.status.should == 400
      end
    end

    context "with valid parameters" do
      it "creates a line item for the order" do
        post api("/orders/#{order_kind}/#{order.merchant_order_no}/line_items"), valid_params

        response.status.should == 201
      end
    end

    context "when the order state is not 'generated'" do
      let(:order) { create(:third_party_order, :wait_check) }

      it "raise 403 Forbidden error" do
        post api("/orders/#{order_kind}/#{order.merchant_order_no}/line_items"), valid_params

        response.status.should == 403
      end
    end
  end

  describe "PUT orders/:kind/:id/transactions/completed/:merchant_trade_no" do
    let(:order_kind) { 'taobao' }
    let(:merchant_trade_no) { '2013123011001001920013924875' }

    let(:valid_params) do
      {
        merchant_name: 'Alipay',
        payment: 299.0
      }
    end

    let(:invalid_params) do
      {
        merchant_name: 'Alipay',
      }
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        put api("/orders/#{order_kind}/#{order.merchant_order_no}/transactions/completed/#{merchant_trade_no}"), invalid_params

        response.status.should == 400
      end
    end

    context "when the id of the order kind not found" do
      it "returns 404 not found error" do
        put api("/orders/#{order_kind}/wrong_id/transactions/completed/#{merchant_trade_no}"), valid_params

        response.status.should == 404
      end
    end

    context "when the state of the order is not 'generated'" do
      let(:order) { create(:third_party_order, :wait_check) }

      it "do nothing and return success" do
        put api("/orders/#{order_kind}/#{order.merchant_order_no}/transactions/completed/#{merchant_trade_no}"), valid_params

        response.status.should == 204
      end
    end

    context "with valid parameters and order state" do
      context "when the merchant_trade_no already exists" do
        let(:order) { create(:third_party_order, :generated, :with_one_transaction) }
        let(:transaction) { order.transaction.start; order.transaction }
        let(:valid_params) do
          {
            merchant_name: transaction.merchant_name,
            payment: 299.0
          }
        end

        it "updates the old transaction, setting it successful" do
          put api("/orders/#{order.kind}/#{order.merchant_order_no}/transactions/completed/#{transaction.merchant_trade_no}"), valid_params

          response.status.should == 205
          transaction.reload.state.should == 'completed'
        end
      end

      context "when the merchant_trade_no does not exists" do
        let(:order) { create(:third_party_order) }
        let(:merchant_trade_no)  { '2013123011001001920013924875' }
        let(:valid_params) do
          {
            merchant_name: 'Alipay',
            payment: 299.0
          }
        end

        it "creates a new transaction and set it successful" do
          put api("/orders/#{order.kind}/#{order.merchant_order_no}/transactions/completed/#{merchant_trade_no}"), valid_params

          response.status.should == 205
          order.transaction.merchant_trade_no.should == '2013123011001001920013924875'
          order.transaction.state.should == 'completed'
        end
      end
    end
  end

  describe "PUT orders/completed/:kind/:id" do
    context "when the id of the order kind not found" do
      it "returns 404 not found error" do
        put api("/orders/completed/taobao/wrong_id")

        response.status.should == 404
      end
    end

    context "when the state of the order is not 'wait_confirm'" do
      let(:order) { create(:third_party_order, :wait_check) }

      it "raise 403 Forbidden error" do
        put api("/orders/completed/#{order.kind}/#{order.merchant_order_no}")

        response.status.should == 403
      end
    end

    context "when the state of the order is 'completed'" do
      let(:order) { create(:third_party_order, :completed) }

      it "do nothing and return success" do
        put api("/orders/completed/#{order.kind}/#{order.merchant_order_no}")

        response.status.should == 204
      end
    end

    context "when the state of the order is 'wait_confirm'" do
      let(:order) { create(:third_party_order, :wait_confirm) }

      it "complete the order" do
        put api("/orders/completed/#{order.kind}/#{order.merchant_order_no}")

        order.reload.state.should == 'completed'
        response.status.should == 205
      end
    end

  end

  describe "PUT orders/:kind/:id/memos" do
    let(:order) { create(:third_party_order, :wait_confirm) }
    let(:special_instructions) { "最好能在3/8前送到，谢谢。" }
    let(:memo) { "送达时间：3/8号前，时间随意" }
    let(:valid_params) { { special_instructions: special_instructions, memo: memo } }

    it "returns success" do
      put api("/orders/#{order.kind}/#{order.merchant_order_no}/memos"), valid_params

      response.status.should == 205
    end

    it "updates memos of the order" do
      put api("/orders/#{order.kind}/#{order.merchant_order_no}/memos"), valid_params

      order.reload.special_instructions.should == special_instructions
      order.memo.should == memo
    end
  end

  describe "POST orders/:kind/:id/refunds" do
    let(:order) { create(:third_party_order, :wait_confirm, :with_one_transaction) }
    let(:transaction) { create(:transaction, order: order, state: 'completed') }

    let(:valid_params) do
      {
        merchant_trade_no: transaction.merchant_trade_no,
        merchant_refund_id: "118388942384",
        amount: 299.0,
        reason: "未收到花盒"
      }
    end

    let(:invalid_params) do
      {
        merchant_trade_no: transaction.merchant_trade_no,
        merchant_refund_id: "118388942384",
        reason: "未收到花盒"
      }
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        post api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds"), invalid_params

        response.status.should == 400
      end
    end

    context "with valid parameters" do
      context "when the merchant_trade_no not found" do
        let(:valid_params) do
          {
            merchant_trade_no: "20492984234032948923",
            merchant_refund_id: "118388942384",
            amount: 299.0,
            reason: "未收到花盒"
          }
        end

        it "returns 400 bad request error" do
          post api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds"), valid_params

          response.status.should == 400
        end
      end

      context "when the merchant_refund_id exists already" do
        before do
          create(:refund, merchant_refund_id: valid_params[:merchant_refund_id], order: order)
        end

        it "do nothing and return success" do
          post api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds"), valid_params

          response.status.should == 201
        end
      end

      it "returns success" do
        post api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds"), valid_params

        response.status.should == 201
      end

      it "creates an refund" do
        lambda {
          post api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds"), valid_params
        }.should change { order.refunds.count }.by(1)
      end
    end
  end

  describe "PUT orders/:kind/:id/refunds/accepted/:merchant_refund_id" do
    let(:order) { create(:third_party_order, :wait_refund, :with_one_transaction) }
    let(:transaction) { create(:transaction, order: order, state: 'completed') }
    let(:refund) { create(:refund, order: order, transaction: transaction) }
    let(:merchant_refund_id) { refund.merchant_refund_id }

    let(:valid_params) do
      {
        merchant_trade_no: transaction.merchant_trade_no,
        amount: 299.0,
        reason: "未收到花盒"
      }
    end

    let(:invalid_params) do
      {
        merchant_trade_no: transaction.merchant_trade_no,
        reason: "未收到花盒"
      }
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        put api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds/accepted/#{merchant_refund_id}"), invalid_params

        response.status.should == 400
      end
    end

    context "with valid parameters" do
      context "when the merchant_refund_id does not exist" do
        let(:merchant_refund_id) { "942389482942394823423" }

        it "creates an refund and accept it" do
          lambda {
            put api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds/accepted/#{merchant_refund_id}"), valid_params
          }.should change { order.refunds.count }.by(1)
        end
      end

      it "return success" do
        put api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds/accepted/#{merchant_refund_id}"), valid_params

        response.status.should == 205
      end

      it "set the refund state to 'accepted'" do
        put api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds/accepted/#{merchant_refund_id}"), valid_params

        refund.reload.state.should == 'accepted'
      end

      it "set the order state to 'refunded'" do
        put api("/orders/#{order.kind}/#{order.merchant_order_no}/refunds/accepted/#{merchant_refund_id}"), valid_params

        order.reload.state.should == 'refunded'
      end
    end
  end

end
