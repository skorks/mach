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
        mac_id = hmac_request.mac_id
        timestamp_valid = Mach::Validation::TimestampValidator.valid?(hmac_request)
        nonce_valid = Mach::Validation::NonceValidator.valid?(hmac_request)
        signature_valid = Mach::Validation::SignatureValidator.valid?(hmac_request)
        valid = mac_id && timestamp_valid && nonce_valid && signature_valid

        if valid
          #need to make sure we store the nonce
          Nonce.persist(hmac_request.mac_id, hmac_request.mac_nonce, hmac_request.mac_timestamp.to_i)
        else
          logger.error("mac token validation failure for mac_id=#{mac_id}, nonce_valid=#{nonce_valid}, timestamp_valid=#{timestamp_valid}, signature_valid=#{signature_valid}")
        end

        if !valid && Mach.configuration.ignore_validation_failure
          logger.warn("WARNING: Ignoring Request Validation failure, Are you sure you want to do it?")
          return true
        end
        valid
      end

      def logger
        Mach.config.logger
      end
    end
  end
end
