# encoding: utf-8
require 'spec_helper'

describe Billing::Base do
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

  let(:type) { [:gateway, :return, :notify].sample }
  let(:query) { 'hello=world' }

  context 'validate types' do
    let(:type) { :other }

    it 'raises error if type isnt among gateway, return and notify' do
      lambda { Billing::Base.new type, transaction, query }.should raise_error ArgumentError, 'Billing should have the types among gateway, return and notify.'
    end
  end

  context 'validate transactions' do
    [:paymethod, :identifier, :amount].each do |attr|
      it "should raise an error if #{attr} are missing" do
        transaction[attr] = nil
        lambda { Billing::Base.new type, transaction, query }.should raise_error ArgumentError, "the transaction object missing required attributes #{attr}"
      end
    end

    it 'should raise an error if the paymethod is not valid' do
      transaction[:paymethod] = 'invalid_paymethod'
      lambda { Billing::Base.new type, transaction, query }.should raise_error ArgumentError, 'invalid paymethod'
    end
  end

  context 'create the billing instance' do
    context 'type == :gateway' do
      let(:type) { :gateway }

      it 'return an Billing::Return::Alipay instance if paymethod is directPay' do
        transaction[:paymethod] = 'directPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Gateway::Alipay
      end

      it 'return an Billing::Return::Alipay instance if paymethod is bankPay' do
        transaction[:paymethod] = 'bankPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Gateway::Alipay
      end

      it 'return an Billing::Return::Paypal instance if paymethod is paypal' do
        transaction[:paymethod] = 'paypal'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Gateway::Paypal
      end
    end

    context 'type == :return' do
      let(:type) { :return }

      it 'should raise an error if the query_string is not present' do
        query = nil
        lambda { Billing::Base.new type, transaction, query }.should raise_error ArgumentError, 'the return query string is required'
      end

      it 'should return an Billing::Return::Alipay instance if paymethod is directPay' do
        transaction[:paymethod] = 'directPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Return::Alipay
      end

      it 'should return an Billing::Return::Alipay instance if paymethod is bankPay' do
        transaction[:paymethod] = 'bankPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Return::Alipay
      end

      it 'should return an Billing::Return::Paypal instance if paymethod is paypal' do
        transaction[:paymethod] = 'paypal'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Return::Paypal
      end
    end

    context 'type == :notify' do
      let(:type) { :notify }

      it 'should raise an error if the query_string is not present' do
        query = nil
        lambda { Billing::Base.new type, transaction, query }.should raise_error ArgumentError, 'the notify query string is required'
      end

      it 'should return an Billing::Notify::Alipay instance if paymethod is directPay' do
        transaction[:paymethod] = 'directPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Notify::Alipay
      end

      it 'should return an Billing::Notify::Alipay instance if paymethod is bankPay' do
        transaction[:paymethod] = 'bankPay'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Notify::Alipay
      end

      it 'should return an Billing::Notify::Paypal instance if paymethod is paypal' do
        transaction[:paymethod] = 'paypal'
        Billing::Base.new(type, transaction, query).should be_kind_of Billing::Notify::Paypal
      end
    end
  end
end
