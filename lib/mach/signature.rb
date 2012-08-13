require 'openssl'
require 'base64'

module Mach
  class Signature
    ALGORITHMS = {'hmac-sha-256' => 'sha256', 'hmac-sha-1' => 'sha1'}
    DEFAULT_ALGORITHM = 'hmac-sha-256'

    def initialize(base64_key, data, algorithm = DEFAULT_ALGORITHM)
      @algorithm = algorithm
      @data = data
      @base64_key = base64_key
    end

    def to_s
      Base64.strict_encode64(OpenSSL::HMAC.digest(digest, decoded_key, @data))
    end

    private
    def digest
      digest_algorithm = @algorithm ? ALGORITHMS[@algorithm] : ALGORITHMS[DEFAULT_ALGORITHM]
      OpenSSL::Digest::Digest.new(digest_algorithm)
    end

    def decoded_key
      Base64.strict_decode64(@base64_key)
      #TODO possibly need to make this a bit more permissive allowing strict and non strict, i.e catch the exception
    end
  end
end
