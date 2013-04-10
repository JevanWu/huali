# encoding: utf-8

require 'spec_helper'

describe Billing::Gateway do
  context '#initialize' do
    let(:transaction) do
      {
        # in: %w(paypal directPay bankPay),
        paymethod: 'directPay', # required
        identifier: 'TR1303130011', # required
        amount: 359, # required
        subject: '琥珀 x 1', # required
        body: nil,
        merchant_name: 'CMB'
      }
    end

    [:paymethod, :identifier, :amount, :subject].each do |attr|
      it "should raise an error if #{attr} are missing" do
        transaction[attr] = nil
        lambda { Billing::Gateway.new transaction }.should raise_error ArgumentError, "the transaction object missing required attributes #{attr}"
      end
    end

    it 'should raise an error if the paymethod is not valid' do
      transaction[:paymethod] = 'invalid_paymethod'
      lambda { Billing::Gateway.new transaction }.should raise_error ArgumentError, 'invalid paymethod'
    end

    it 'should return an Billing::Gateway::Alipay instance if paymethod is directPay' do
      transaction[:paymethod] = 'directPay'
      Billing::Gateway.new(transaction).should be_kind_of(Billing::Gateway::Alipay)
    end


    it 'should return an Billing::Gateway::Alipay instance if paymethod is bankPay' do
      transaction[:paymethod] = 'bankPay'
      Billing::Gateway.new(transaction).should be_kind_of(Billing::Gateway::Alipay)
    end

    it 'should return an Billing::Gateway::Paypal instance if paymethod is paypal' do
      transaction[:paymethod] = 'paypal'
      Billing::Gateway.new(transaction).should be_kind_of(Billing::Gateway::Paypal)
    end
  end

  context 'transaction#paymethod is directPay' do
    let(:transaction) do
      {
        # in: %w(paypal directPay bankPay),
        paymethod: 'directPay', # required
        identifier: 'TR1303130011', # required
        amount: 359, # required
        subject: '琥珀 x 1', # required
        body: nil,
        merchant_name: nil
      }
    end

    describe '#purchase_path' do
      it 'is a valid alipay payment address' do

      end

      it 'redirects the user to the alipay page' do

      end

      it 'contains the RMB amount to be claimed on the page' do

      end

      it 'contains the subject to be claimed on the page' do

      end
    end
  end

  context 'transaction#paymethod is bankpay' do
    let(:transaction) do
      {
        # in: %w(paypal directPay bankPay),
        paymethod: 'bankPay', # required
        identifier: 'TR1303130011', # required
        amount: 359, # required
        subject: '琥珀 x 1', # required
        body: nil,
        merchant_name: 'CMB'
      }
    end

    it 'raise an error if merchant_name is missing' do
      transaction[:merchant_name] = nil
      lambda { Billing::Gateway.new transaction }.should raise_error ArgumentError, 'merchant_name is required for bankPay'
    end

    describe '#purchase_path' do
      it 'is a valid bankpay payment address' do
        # follow the redirection and validate against the html
      end

      it 'redirects the user to the correct bank payment page' do

      end

      it 'contains the RMB amount to be claimed on the page' do

      end

      it 'contains the subject to be claimed on the page' do

      end
    end
  end

  context 'transaction#paymethod is paypal' do
    let(:transaction) do
      {
        # in: %w(paypal directPay bankPay),
        paymethod: 'paypal', # required
        identifier: 'TR1303130011', # required
        amount: 359, # required
        subject: '琥珀 x 1', # required
        body: nil,
        merchant_name: nil
      }
    end

    it 'should convert the RMB amount 399 to dollar $69.99' do
      transaction[:amount] = 399
      gateway = Billing::Gateway.new(transaction)

      gateway.purchase_path.index('amount=69.99').should_not be_nil
    end

    it 'should convert the RMB amount 199 to dollar $34.99' do
      transaction[:amount] = 199
      gateway = Billing::Gateway.new(transaction)

      gateway.purchase_path.index('amount=34.99').should_not be_nil
    end

    describe '#purchase_path' do
      it 'is a valid paypal payment address' do
        # follow the redirection and validate against the html
      end

      it 'redirects the user to the paypal page' do

      end

      it 'contains the dollar amount to be claimed on the page' do

      end

      it 'contains the subject to be claimed on the page' do

      end
    end
  end

  # TODO add the test on custom data
end
