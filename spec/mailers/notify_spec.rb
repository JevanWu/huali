# encoding: utf-8
require 'spec_helper'

describe Notify do
  describe "#unpaid_orders_email" do
    let(:mail) { Notify.unpaid_orders_email }
    before(:each) do
      create(:order, created_at: 3.hours.ago)
      Huali::Application.config.action_mailer.default_url_options = { host: 'localhost' }
    end


    it "renders the headers" do
      mail.content_type.should eq('text/html; charset=UTF-8')
      mail.subject.should match "未支付订单"
      mail.to.should eq(["support@hua.li"])
    end

    it "renders the body" do
      mail.body.should match("未支付订单")
    end
  end
end
