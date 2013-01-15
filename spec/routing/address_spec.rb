require 'spec_helper'

describe "routes for Province, City and Area", type: :routing do
  it "route to provinces" do
    { get: "/provinces" }.should route_to "provinces#index"
  end

  it "route to individual provinces" do
    { get: "/provinces/31" }.should route_to(
      {"controller"=>"provinces", "action"=>"show", "prov_id"=>"31"}
    )

  end

  it "route to cities belong to a province" do
    { get: "/provinces/31/cities" }.should route_to(
      {"controller"=>"cities", "action"=>"index", "prov_id"=>"31"}
    )
  end

  it "route to individual city" do
    { get: "/cities/312" }.should route_to(
      {"controller"=>"cities", "action"=>"show", "city_id"=>"312"}
    )
  end

  it "route to areas belong to a city" do
    { get: "/cities/312/areas" }.should route_to(
      {"controller"=>"areas", "action"=>"index", "city_id"=>"312"}
    )
  end

  it "route to individual areas" do
    { get: "/areas/234" }.should route_to(
      {"controller"=>"areas", "action"=>"show", "area_id"=>"234"}
    )
  end
end
