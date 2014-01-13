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
        post api("/orders", valid_order), valid_order
        response.status.should == 201
      end
    end

    context "when not providing required parameters" do
      it "should return 400 bad request error" do
        post api("/orders", unvalid_order), unvalid_order
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
          kind: 'xxorder',
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
        post api("/orders", unvalid_order), unvalid_order
        response.status.should == 400
        response.body.should match("kind")
      end
    end
  end

  let(:order) { create(:third_party_order, :without_line_items) }

  describe "POST /orders/:id/line_items" do
    let(:product) { create(:product) }
    let(:invalid_params) { { price: 299, quantity: 2, kind: 'taobao' } }
    let(:valid_params) { { product_id: product.id , price: 299, quantity: 2, kind: 'taobao' } }

    context "when the id of the order kind not found" do
      it "returns 404 not found error" do
        post api("/orders/8829/line_items", valid_params), valid_params

        response.status.should == 404
      end
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        post api("/orders/#{order.merchant_order_no}/line_items", invalid_params), invalid_params

        response.status.should == 400
      end
    end

    context "with valid parameters" do
      it "creates a line item for the order" do
        post api("/orders/#{order.merchant_order_no}/line_items", valid_params), valid_params

        response.status.should == 201
      end
    end

    context "when the order state is not 'generated'" do
      let(:order) { create(:order, :wait_check, merchant_order_no: '511862112300756', kind: 'taobao') }

      it "raise 403 Forbidden error" do
        post api("/orders/#{order.merchant_order_no}/line_items", valid_params), valid_params

        response.status.should == 403
      end
    end
  end

  describe "POST orders/:id/pay" do
    let(:valid_params) do
      {
        merchant_trade_no: '2013123011001001920013924875',
        merchant_name: 'Alipay',
        kind: 'taobao',
        payment: 299.0
      }
    end

    let(:invalid_params) do
      {
        merchant_trade_no: '2013123011001001920013924875',
        merchant_name: 'Alipay',
        kind: 'taobao'
      }
    end

    context "with invalid parameters" do
      it "returns 400 bad request error" do
        post api("/orders/#{order.merchant_order_no}/pay", invalid_params), invalid_params

        response.status.should == 400
      end
    end

    context "when the id of the order kind not found" do
      it "returns 404 not found error" do
        post api("/orders/wrong_id/pay", valid_params), valid_params

        response.status.should == 404
      end
    end

    context "when the state of the order is not 'generated'" do
      let(:order) { create(:order, :wait_check, merchant_order_no: '511862112300756', kind: 'taobao') }

      it "raise 403 Forbidden error" do
        post api("/orders/#{order.merchant_order_no}/pay", valid_params), valid_params

        response.status.should == 403
      end
    end

    context "with valid parameters and order state" do
      context "when the merchant_trade_no already exists" do
        let(:order) { create(:third_party_order, :with_one_transaction) }
        let(:transaction) { order.transaction.start; order.transaction }
        let(:valid_params) do
          {
            merchant_trade_no: transaction.merchant_trade_no,
            merchant_name: transaction.merchant_name,
            kind: order.kind,
            payment: 299.0
          }
        end

        it "updates the old transaction, setting it successful" do
          post api("/orders/#{order.merchant_order_no}/pay", valid_params), valid_params

          transaction.reload.state.should == 'completed'
          response.status.should == 200
        end
      end

      context "when the merchant_trade_no already exists" do
        let(:order) { create(:third_party_order) }
        let(:valid_params) do
          {
            merchant_trade_no: '2013123011001001920013924875',
            merchant_name: 'Alipay',
            kind: 'taobao',
            payment: 299.0
          }
        end

        it "creates a new transaction and set it successful" do
          post api("/orders/#{order.merchant_order_no}/pay", valid_params), valid_params

          response.status.should == 200
          order.transaction.merchant_trade_no.should == '2013123011001001920013924875'
          order.transaction.state.should == 'completed'
        end
      end
    end
  end
end
