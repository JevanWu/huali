shared_examples_for "#to_coupon_rule_opts" do
  describe "#to_coupon_rule_opts" do
    it "return a hash with keys: :total_price and :products" do
      subject.to_coupon_rule_opts.should have_key(:total_price)
      subject.to_coupon_rule_opts.should have_key(:products)
    end
  end
end
