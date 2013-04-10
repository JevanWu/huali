module Billing
  class Gateway
    class Base
      include Rails.application.routes.url_helpers

      # need to define **#default_opts** and **#to_options**
      # to use the Base class
      def initialize(opts)
        @opts = opts
        @options = default_opts.merge to_options(opts)
      end

      private

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

      def custom_data
        '?' + URI.encode_www_form(custom_id: @opts[:identifier])
      end
    end
  end
end
