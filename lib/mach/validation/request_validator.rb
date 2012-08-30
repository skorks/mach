require 'mach/error/error'
require 'mach/request'
require 'mach/validation/timestamp_validator'
require 'mach/validation/nonce_validator'
require 'mach/validation/signature_validator'

module Mach
  class RequestValidator
    class << self
      def valid?(rack_request)
        hmac_request = Mach::Request.new(rack_request.env)
        raise Mach::Error::RequestNotMacAuthenticatedError unless hmac_request.mac_authorization?
        valid = hmac_request.mac_id &&
          Mach::Validation::TimestampValidator.valid?(hmac_request) &&
          Mach::Validation::NonceValidator.valid?(hmac_request) &&
          Mach::Validation::SignatureValidator.valid?(hmac_request)
        #need to make sure we store the nonce
        Nonce.persist(hmac_request.mac_id, hmac_request.mac_nonce, hmac_request.mac_timestamp.to_i) if valid
        valid
      end
    end
  end
end
