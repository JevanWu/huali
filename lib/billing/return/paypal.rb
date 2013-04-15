require 'uri'
require 'ostruct'

module Billing
  class Return
    class Paypal < OpenStruct
      include Billing::Helper::Paypal

      attr_accessor :params

      def initialize(opts, query_string)
        @opts = opts
        reset!
        result = parse(query_string)
        result['trade_no'] = result['tx']
        result['payment_status'] = result['st']

        super result
      end

      def success?
        right_amount? && payment_status == "Completed"
      end

      private

      def reset!
        params = {}
      end

      def parse(query_string)
        return {} if query_string.blank?

        @params = query_string.split('&').inject({}) do |memo, chunk|
          next if chunk.empty?
          key, value = chunk.split('=', 2)
          next if key.empty?
          value = value.nil? ? nil : URI.decode(value)
          memo[URI.decode(key)] = value
          memo
        end
      end

      def right_amount?
        amt.to_f == to_dollar(@opts[:amount])
      end
    end
  end
end
