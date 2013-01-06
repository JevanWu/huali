require 'uri'
require 'ostruct'

module Billing
  module Alipay
    class Notification < OpenStruct
      include Helper

      attr_accessor :params
      attr_accessor :raw

      def initialize(post)
        reset!

        # delegates OpenStruct.new to build all arbitrary attributes
        # cover ALL Alipay notify params
        super parse(post)
      end

      def complete?
        trade_status == "TRADE_FINISHED"
      end

      def pending?
        trade_status == 'WAIT_BUYER_PAY'
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
      end
    end
  end
end
