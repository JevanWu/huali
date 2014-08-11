require 'spec_helper'

describe MobileAPI::API do

  let(:user){ create(:user, email: "jevan@hua.li", password: "12345678") }

  describe "GET /mobile_api/v1/users/sign_in" do
    it "return user authentication token" do
      post "/mobile_api/v1/users/sign_in", email: user.email, password: user.password
      response.status.should == 201
      response.body.should match(user.authentication_token)
    end
  end

  # describe "GET /mobile_api/slides/:id" do
  #   it "return a slide depends on the :id" do
  #     get "/mobile_api/v1/slides/#{required_slide.id}"
  #     response.status.should == 200
  #     response.body.should match("required slide")
  #   end
  # end
end
