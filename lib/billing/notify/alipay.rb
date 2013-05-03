require 'uri'
require 'ostruct'

module Billing
  class Notify
    class Alipay < OpenStruct
      include Billing::Helper::Alipay

      attr_accessor :params, :raw

      def initialize(opts, post)
        @opts = opts
        reset!

        # delegates OpenStruct.new to build all arbitrary attributes
        # cover ALL Alipay notify params
        super parse(post)
      end

      private

      # reset the notification.
      def reset!
        @params  = {}
        @raw     = ""
      end

      # Take the posted data and move the relevant data into a hash
      def parse(post)
        @raw = post.to_s
        for line in @raw.split('&')
          key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
          params[key] = URI.decode(value)
        end
        params
      end
    end
  end
end