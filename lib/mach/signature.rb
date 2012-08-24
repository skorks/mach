require 'openssl'
require 'base64'

module Mach
  class Signature
    ALGORITHMS = {'hmac-sha-256' => 'sha256', 'hmac-sha-1' => 'sha1'}
    DEFAULT_ALGORITHM = 'hmac-sha-256'

    def initialize(key, data, algorithm = DEFAULT_ALGORITHM)
      @algorithm = algorithm
      @data = data
      @key = key
    end

    def to_s
      Base64.strict_encode64(OpenSSL::HMAC.digest(digest, @key, @data))
    end

    def matches?(base64_expected_signature)
      to_s == base64_expected_signature
    end

    private

    def digest
      digest_algorithm = @algorithm ? ALGORITHMS[@algorithm] : ALGORITHMS[DEFAULT_ALGORITHM]
      OpenSSL::Digest::Digest.new(digest_algorithm)
    end
  end
end
