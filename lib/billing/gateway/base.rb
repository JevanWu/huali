module Billing
  module Gateway
    class Base
      include Rails.application.routes.url_helpers

      def initialize(opts, query = nil)
        @opts = opts
        @options = default_opts.merge to_options(opts)
      end

      private

      def default_opts
        raise NoMethodError, 'need to define #default_opts in inherited class'
      end

      def to_options
        raise NoMethodError, 'need to define #to_options in inherited class'
      end

      def query_string
        compacted_options.map do |k, v|
          "#{k}=#{v}"
        end.sort * '&'
      end

      def compacted_options
        @options.select do |key, value|
          not value.blank?
        end
      end
    end
  end
end
