require 'uri'
require 'ostruct'

module Billing
  class Return
    class Alipay < OpenStruct
      include Billing::Helper::Alipay

      attr_accessor :params

      def initialize(opts, query_string)
        @opts = opts
        reset!
        # delegates OpenStruct.new to build all arbitrary attributes
        # cover ALL Alipay notify params
        super parse(query_string)
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
    end
  end
end
