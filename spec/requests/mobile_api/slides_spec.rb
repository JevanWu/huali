require 'spec_helper'

describe MobileAPI::API do

  describe "GET /mobile_api/v1//slides" do
    it "returns all visible slides" do
      FactoryGirl.create_list(:slide_panel, 3, visible: true, priority: 5)
      get "/mobile_api/v1/slides"
      response.status.should == 200
      res = JSON.parse response.body
      res.count.should == 3
    end

    it "returns 404 status if there is no available silde" do
      get "/mobile_api/v1/slides"
      response.status.should == 404
    end
  end

  let(:qixijie){ create(:slide_panel, name: "qixijie") }

  describe "GET /mobile_api/slides/:id" do
    it "queries a slide by the :id" do
      get "/mobile_api/v1/slides/#{qixijie.id}"
      response.status.should == 200
      response.body.should match("qixijie")
    end

    it "return 404 status if the slide does not exist" do
      get "/mobile_api/v1/slides/1"
      response.status.should == 404
    end
  end
end
