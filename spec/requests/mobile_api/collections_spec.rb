require 'spec_helper'

describe MobileAPI::API do

  before do
    child = FactoryGirl.create(:collection, name_en: "child")
    parent = FactoryGirl.create(:collection, name_en: "parent")
    parent.children << child
  end

  describe "GET /mobile_api/v1/collections" do
    it "return all available collections" do
      get "/mobile_api/v1/collections"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 1
      res_arr[0]["name_en"].should == "parent"
      res_arr[0]["children_collections"][0]["name_en"].should == "child"
    end
  end
end
