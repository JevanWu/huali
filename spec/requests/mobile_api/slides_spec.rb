require 'spec_helper'

describe MobileAPI::API do

  before do
    FactoryGirl.create_list(:slide_panel, 3, visible: true, priority: 5)
  end

  let(:required_slide){ create(:slide_panel, name: "required slide") }

  describe "GET /mobile_api/v1//slides" do
    it "return all visible slides" do
      get "/mobile_api/v1/slides"
      response.status.should == 200
      res_arr = JSON.parse response.body
      res_arr.count.should == 3
    end
  end

  describe "GET /mobile_api/slides/:id" do
    it "return a slide depends on the :id" do
      get "/mobile_api/v1/slides/#{required_slide.id}"
      response.status.should == 200
      response.body.should match("required slide")
    end
  end
end
