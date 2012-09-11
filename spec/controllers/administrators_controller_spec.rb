require 'spec_helper'

describe AdministratorsController do

  before (:each) do
    @administrator = FactoryGirl.create(:administrator)
    sign_in @administrator
  end

  describe "GET 'show'" do

    it "should be successful" do
      get :show, :id => @administrator.id
      response.should be_success
    end

    it "should find the right administrator" do
      get :show, :id => @administrator.id
      assigns(:administrator).should == @administrator
    end

  end

end
