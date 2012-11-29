require 'spec_helper'

describe "Products" do
  describe "GET /products" do
    xit "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get product_path(1)
      response.status.should be(200)
    end
  end
end
