require 'spec_helper'

describe BannersController do
  before do
    @banner = create(:banner)
  end

  describe "GET index" do
    context "when the date provided is of invalid format" do
      it "returns nothing" do
        get :index, date: "new_device_id_xxx"

        response.body.should be_blank
      end
    end

    context "when the date provided is of valid format" do
      it "returns array of banner JSON" do
        get :index, date: "2013-09-19"

        assigns(:banners).should include(@banner)
        response.body.should == [@banner].to_json
      end
    end
  end
end
