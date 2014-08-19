require 'spec_helper'

describe MobileAPI::API do
  include ApiHelpers

  before do
    import_region_data_from_files
  end

  let(:current_user) { create(:user) }
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

  describe "GET /mobile_api/v1/orders" do
    it "returns all of the orders of current user" do
      FactoryGirl.create_list(:order, 3, user: current_user)
      get "/mobile_api/v1/orders", email: current_user.email, token: current_user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body)
      res.count.should == 3
    end
  end

  let(:order) { create(:order, user: current_user) }
  describe "GET /mobile_api/v1/orders/:id" do
    it "queries the order by the :id" do
      get "/mobile_api/v1/orders/#{order.id}", email: current_user.email, token: current_user.authentication_token

      response.status.should == 200 
      response.body.should match(order.identifier)
    end
  end

  describe "POST /mobile_api/v1/orders" do
    it "creates a order" do
      post "/orders", valid_order
      response.status.should == 201
      Order.count.should == 1
    end
  end

  describe "POST /mobile_api/v1/orders/:id/line_items" do
    let(:order) { create(:order, :without_line_items) }
    let(:product) { create(:product) }
    it "creates line items for the order" do
      post "/mobile_api/v1/orders/#{order.id}/line_items", product_id: product.id, price: product.price, quantity: product.quantity
      response.status.should == 201
      response.body.should match(order.line_items.first.id)
    end
  end

  describe "PUT /mobile_api/v1/orders/:id/cancel" do
    let(:order) { create(:order, :generated) }
    it "cancels the order" do
      put "/mobile_api/v1/orders/#{order.id}/cancel" 
      response.status.should == 200
      order.state.should == "void"
    end
  end

  describe "PUT /mobile_api/v1/orders/:id/refund" do
    let(:order) { create(:order, :wait_confirm) }
    it "change the state of the order to 'wait refund'" do
      put "/mobile_api/v1/orders/#{order.id}/refund"
      response.status.should == 200
      order.state.should == "wait_refund"
    end
  end
end
