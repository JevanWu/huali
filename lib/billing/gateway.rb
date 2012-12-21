module Billing
  class Gateway
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
  end
end
