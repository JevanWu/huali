require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/slides" do
    it "return all visible slides" do
      get "/mobile_api/v1/slides"
      response.status.should == 200
    end
  end
end
