require 'ostruct'

module Billing
  module Notify
    class Base < OpenStruct
      attr_accessor :raw
       
      def initialize(opts, post)
        @opts = opts
        reset!
        super parse(post)
      end

      protected

      def reset!
        @params  = {}
        @raw     = ""
      end

      def parse(post)
        @raw = post.to_s
        for line in @raw.split('&')
          key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
          @params[key] = URI.decode(value)
        end
        @params
      end
    end
  end
end
