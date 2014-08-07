require 'spec_helper'

describe MobileAPI::API do

  before do
    ["about us", "contact us", "privacy"].each do |title|
      FactoryGirl.create(:page, title_en: title)
    end
  end

  describe "GET /mobile_api/v1/pages" do
    it "return all published pages" do
      get "/mobile_api/v1/pages"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 3
      response.body.should match("about us")
      response.body.should match("contact us")
      response.body.should match("privacy")
    end
  end
end
