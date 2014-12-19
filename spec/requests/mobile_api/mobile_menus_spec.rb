require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/v1/mobile_menus" do
    it "returns all mobile menus" do
      FactoryGirl.create_list(:mobile_menu, 3)
      get "/mobile_api/v1/mobile_menus"
      response.status.should == 200
      res = JSON.parse response.body
      res.count.should == 3
    end

    it "returns 404 status if there is no available silde" do
      get "/mobile_api/v1/slides"
      response.status.should == 404
    end
  end
end
