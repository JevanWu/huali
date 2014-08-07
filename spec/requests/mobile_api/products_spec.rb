require 'spec_helper'

describe MobileAPI::API do

  before do
    FactoryGirl.create_list(:product, 3)
  end

  let(:required_product){ create(:product, name_en:"required product") }

  describe "GET /mobile_api/v1/products" do
    it "return all published products" do
      get "/mobile_api/v1/products"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 3
    end
  end

  describe "GET /mobile_api/products/:id" do
    it "return a products depends on the params[:id]" do
      get "/mobile_api/v1/products/#{required_product.id}"
      response.status.should == 200
      response.body.should match("required product")
    end
  end
end
