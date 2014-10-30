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
      put "/mobile_api/v1/users", name: "Jevan Wu", phone: "18758161801", email: user.email, token: user.authentication_token
      response.status.should == 200
    end
  end

  describe "GET /mobile_api/v1/users/huali_points" do
    it "returns huali points of the user" do
      get "/mobile_api/v1/users/huali_points", email: user.email, token: user.authentication_token
      response.status.should == 200
      response.body.should match(user.huali_point.to_s)
    end
  end

  describe "GET /mobile_api/v1/users/exist" do
    it "returns true if the user exists" do
      get "/mobile_api/v1/users/exist", email: user.email
      response.status.should == 200
      response.body.should == "true"
    end

    it "returns false if the user does not exist yet" do
      get "/mobile_api/v1/users/exist", email: "new_user@hua.li"
      response.status.should == 200
      response.body.should == "false"
    end
  end

  describe "POST /mobile_api/v1/users/password_reset_sms" do
    it "sends the password-reset code to user" do
      post "/mobile_api/v1/users/password_reset_sms", email: user.email, token: user.authentication_token, phone: user.phone
      response.status.should == 200
    end
  end

  describe "POST /mobile_api/v1/users/reset_password" do
    it "sets the new password for user" do
      reset_token = rand(999999)
      user.update_columns(reset_password_token: reset_token, reset_password_sent_at: Time.now)
      post "/mobile_api/v1/users/reset_password", email: user.email, token: user.authentication_token, password: rand(99999999), reset_token: reset_token
      response.status.should == 200
    end

    it "returns 500 if the reset tokens mismatch" do
      post "/mobile_api/v1/users/reset_password", email: user.email, token: user.authentication_token,  password: rand(99999999), reset_token: rand(999999)
      response.status.should == 500
      response.body.should match("mismatch")
    end
  end
end
