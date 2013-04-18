# encoding: utf-8
require 'spec_helper'

describe Billing::Link do
  let(:type) { :link }

  let(:transaction) do
    {
      # in: %w(paypal directPay bankPay),
      paymethod: 'directPay', # required
      identifier: 'TR1303130011', # required
      amount: 359, # required
      subject: '琥珀 x 1', # required
      body: nil,
      merchant_name: 'CMB',
      merchant_trade_no: '2013041137907535'
    }
  end

  it 'generates the right alipay link for directPay' do
    link = Billing::Base.new(:link, transaction)
    link.to_s.should eql "https://merchantprod.alipay.com/trade/refund/fastPayRefund.htm?tradeNo=2013041137907535&action=detail"
  end

  it 'generates the right alipay link for directPay' do
    transaction[:paymethod] = 'bankPay'
    link = Billing::Base.new(:link, transaction)
    link.to_s.should eql "https://merchantprod.alipay.com/trade/refund/fastPayRefund.htm?tradeNo=2013041137907535&action=detail"
  end

  it 'generates the right alipay link for directPay' do
    transaction[:paymethod] = 'paypal'
    link = Billing::Base.new(:link, transaction)
    link.to_s.should eql "https://www.paypal.com/c2/cgi-bin/webscr?cmd=_view-a-trans&id=2013041137907535"
  end
end
