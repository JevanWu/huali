require 'spec_helper'

describe MobileAPI::API do

  let(:spring){ create(:product, name_en:"spring") }

  describe "GET /mobile_api/v1/products" do
    it "returns all published products" do
      FactoryGirl.create_list(:product, 3)
      get "/mobile_api/v1/products"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 3
    end

    it "returns 404 status if there is no products" do
      get "/mobile_api/v1/products"
      response.status.should == 404
    end
  end

  describe "GET /mobile_api/products/:id" do
    it "return a products depends on the params[:id]" do
      get "/mobile_api/v1/products/#{spring.id}"
      response.status.should == 200
      response.body.should match("spring")
    end

    it "return 404 status if the product cannot be found" do
      get "/mobile_api/v1/products/1"
      response.status.should == 404
    end
  end
end
