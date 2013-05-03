require 'billing/gateway/alipay.rb'
require 'billing/gateway/paypal.rb'
require 'billing/return/alipay.rb'
require 'billing/return/paypal.rb'
require 'billing/notify/alipay.rb'
require 'billing/notify/paypal.rb'
require 'billing/link/alipay.rb'
require 'billing/link/paypal.rb'

module Billing
  class Base
    def self.new(type, transaction, query = nil)
      @type = type
      @transaction = transaction
      @query = query

      unless @type.in? [:gateway, :return, :notify, :link]
        raise ArgumentError, "invalid types for Billing"
      end

      validate_transaction(@transaction)

      # make the internal shared data structure explicit
      @opts = Hash.new
      [:paymethod, :identifier, :amount, :subject, :body, :merchant_name, :merchant_trade_no].each do |attr|
        @opts[attr] = @transaction[attr]
      end

      if @type.in? [:return, :notify]
        validate_query; identify_transaction
      end

      if @type.in? [:link]
        validate_merchant_trade_no
      end

      # create instance dynamically
      # Billing::Gateway::Alipay
      case @opts[:paymethod]
      when "directPay", "bankPay"
        Billing.const_get(@type.capitalize).const_get(:Alipay).new(@opts, @query)
      when "paypal"
        Billing.const_get(@type.capitalize).const_get(:Paypal).new(@opts, @query)
      end
    end

    def self.validate_query
      raise ArgumentError, "the #@type query string is required" unless @query
    end

    def self.identify_transaction
      raise StandardError, 'transaction doesnt match the custom_id in query_string' unless @query.match(@opts[:identifier])
    end

    def self.validate_transaction(transaction)
      [:paymethod, :identifier, :amount].each do |attr|
        raise ArgumentError, "the transaction object missing required attributes #{attr}" unless transaction[attr]
      end

      unless transaction[:paymethod].in? %w(paypal directPay bankPay)
        raise ArgumentError, 'invalid paymethod'
      end
    end

    def self.validate_merchant_trade_no
      raise ArgumentError, 'merchant_trade_no is required' if @opts[:merchant_trade_no].nil?
    end
  end
end