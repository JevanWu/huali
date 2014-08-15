require 'spec_helper'

describe MobileAPI::API do

  describe "GET /orders" do
    it "returns all of the orders of current user" do
      get "/orders"
      response.status = 200
    end
  end

  describe "GET /orders/:id" do

  end

  describe "POST /orders" do

  end

  describe "POST /orders/:id/line_items" do
  end

  describe "PUT /orders/:id/cancel" do
  end

  describe "PUT /orders/:id/refund" do
  end
end
