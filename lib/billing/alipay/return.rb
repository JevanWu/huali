# encoding: utf-8
require 'uri'
require 'ostruct'

module Billing
  module Alipay
    class Return < OpenStruct
      include Helper

      attr_accessor :params

      def initialize(query_string)
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
