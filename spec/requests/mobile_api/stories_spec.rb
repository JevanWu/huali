require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/v1/stories" do
    it "returns all visible stories" do
      FactoryGirl.create_list(:story, 3)
      get "/mobile_api/v1/stories"
      response.status.should == 200
      res = JSON.parse response.body
      res.count.should == 3
    end

    it "returns 404 status if there is no available story" do
      get "/mobile_api/v1/stories"
      response.status.should == 404
    end
  end
end
