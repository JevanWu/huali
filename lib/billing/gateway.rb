require 'billing/gateway/alipay'
require 'billing/gateway/paypal'

module Billing
  class Gateway
    class << self
      def new(transaction)
        return unless self.validate(transaction)

        # make the internal shared data structure explicit
        opts = Hash.new
        [:paymethod, :identifier, :amount, :subject, :body, :merchant_name].each do |attr|
          opts[attr] = transaction[attr]
        end

        case opts[:paymethod]
        when "directPay", "bankPay"
          Alipay.new(opts)
        when "paypal"
          Paypal.new(opts)
        end
      end

      def validate(transaction)
        [:paymethod, :identifier, :amount, :subject].each do |attr|
          raise ArgumentError, "the transaction object missing required attributes #{attr}" unless transaction[attr]
        end

        unless transaction[:paymethod].in? %w(paypal directPay bankPay)
          raise ArgumentError, 'invalid paymethod'
        end

        return true
      end
    end
  end
end
