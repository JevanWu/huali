require 'spec_helper'

describe API::API do
  include ApiHelpers

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
end
