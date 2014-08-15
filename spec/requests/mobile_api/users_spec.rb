require 'spec_helper'

describe MobileAPI::API do

  let(:user){ create(:user, huali_point: 300.0) }

  describe "POST /mobile_api/v1/users/sign_in" do
    it "returns user authentication token" do
      post "/mobile_api/v1/users/sign_in", email: user.email, password: user.password
      response.status.should == 200
      response.body.should match(user.authentication_token)
    end

    it "returns 404 status if the user does not exit" do
      post "/mobile_api/v1/users/sign_in", email: "jevan@hua.li", password: "12345678"
      response.status.should == 404 
    end

    it "returns 500 status if the passowrd is wrong" do
      post "/mobile_api/v1/users/sign_in", email: user.email, password: "12345678"
      response.status.should == 500 
    end
  end

  describe "POST /mobile_api/v1/users" do
    it "registers a user" do
      post "/mobile_api/v1/users", email: "jevan@hua.li", password: "12345678", name: "Jevan", phone: "18758161801" 
      response.status.should == 201
    end

    it "returns 500 status if signing up failed" do
      post "/mobile_api/v1/users", email: "jevan@hua.li", password: "12345678", name: "Jevan", phone: "1875" 
      response.status.should == 500 
    end
  end

  describe "PUT /mobile_api/v1/users/change_password" do
    it "changes the password of user" do
      put "/mobile_api/v1/users/change_password", password: user.password, new_password: "12345678", email: user.email, token: user.authentication_token
      response.status.should == 200
    end
  end

  describe "PUT /mobile_api/v1/users" do
    it "changes user information" do
      put "/mobile_api/v1/users", name: user.name, phone: "18758161801", email: user.email, token: user.authentication_token
      response.status.should == 200
    end
  end

  describe "GET /mobile_api/v1/users/huali_points" do
    it "returns huali points of the user" do
      get "/mobile_api/v1/users/huali_points", email: user.email, token: user.authentication_token
      response.status.should == 200
      response.body.should match(user.huali_point)
    end
  end
end
