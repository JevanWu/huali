require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/v1/collections" do
    it "returns all available collections" do
      child = FactoryGirl.create(:collection, name_en: "child")
      parent = FactoryGirl.create(:collection, name_en: "parent")
      parent.children << child

      get "/mobile_api/v1/collections"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 1
      res_arr[0]["name_en"].should == "parent"
      res_arr[0]["children_collections"][0]["name_en"].should == "child"
    end

    it "returns 404 status if there is no available collection" do
      get "/mobile_api/v1/collections"
      response.status.should == 404
    end
  end

  describe "GET /mobile_api/v1/collections/:id/products" do
    let(:fresh_flower) { create(:collection) }
    let(:spring) { create(:product) }
    
    it "returns all available products of a collection" do
      spring.collections << fresh_flower unless spring.collections.include?(fresh_flower)
      get "/mobile_api/v1/collections/#{fresh_flower.id}/products"
      response.status.should == 200
      response.body.should match("spring")
    end

    it "returns 404 status if the collection has no any product" do
      get "/mobile_api/v1/collections/#{fresh_flower.id}/products"
      response.status.should == 404
    end
  end
end
