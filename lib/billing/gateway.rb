module Billing
  class Gateway
    private

    def query_string
      compacted_options.sort.map do |key, value|
          "#{key}=#{value}"
      end.join("&")
    end

    def compacted_options
      @options.select do |key, value|
        not (value.nil? or value.empty?)

      end
    end
  end
end
