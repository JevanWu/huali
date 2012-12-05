require 'spec_helper'

describe "routes for Order", type: :routing do
  it "route to show current order" do
    { get: "/orders/current" }.should route_to "orders#current"
  end

  it "route to list historic orders" do
    { get: "/orders" }.should route_to "orders#index"
  end

  it "route to show historic order" do
    { get: "/orders/234" }.should route_to "orders#show"
  end

  it "route to show order creation form" do
    { get: "/orders/new" }.should route_to "orders#new"
  end

  it "route to action to create order" do
    { post: "/orders/create" }.should route_to "orders#create"
  end

  it "doesn't route to action to delete order" do
    { delete: "/orders/234" }.should_not be_routable
  end
end
