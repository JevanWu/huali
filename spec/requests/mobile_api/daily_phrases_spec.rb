require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/v1/daily_phrase" do
    it "returns the last daily phrase" do
      FactoryGirl.create( :daily_phrase )
      get "/mobile_api/v1/daily_phrase"
      response.status.should == 200
    end

    it "returns 404 status if there is no daily phrase" do
      get "/mobile_api/v1/daily_phrase"
      response.status.should == 404
    end
  end
end
