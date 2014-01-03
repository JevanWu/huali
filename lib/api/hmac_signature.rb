require 'openssl'

module API
  class HmacSignature
    def initialize(key)
      @key = key
    end

    def sign(verb, host, path, query_params)
      sorted_query_params = query_params.sort.map { |param| param.join("=") }
      # => ["user=mat", "tag=ruby"]

      canonicalized_params = sorted_query_params.join("&") # => "user=mat&tag=ruby"

      string_to_sign = verb + host + path + canonicalized_params

      digest = OpenSSL::Digest::Digest.new('sha1')
      raw_sign = OpenSSL::HMAC.digest(digest, @key, string_to_sign)
      Base64.encode64(raw_sign).chomp
    end
  end
end
