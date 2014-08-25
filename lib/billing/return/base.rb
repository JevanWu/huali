require 'uri'
require 'ostruct'

module Billing
  module Return
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

        @params = Rack::Utils.parse_nested_query(query_string).
          select { |k, v| k.present? && v.present? }
      end
    end
  end
end
