require 'uri'
require 'ostruct'

module Billing
  class Return
    class Base < OpenStruct

      def initialize(opts, query_string)
        @opts = opts
        reset!
        super parse(query_string)
      end

      protected
      
      def reset!
        @params = {}
      end

      def parse(query_string)
        return @params if query_string.blank?

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
