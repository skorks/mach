require 'mach/signature'

module Mach
  module Validation

    class SignatureValidator
      class << self
        def valid?(hmac_request)
          if secret = credential_store[hmac_request.mac_id]
            data = hmac_request.mac_normalized_request_string
            mach_signature = Mach::Signature.new(secret, data)
            result = mach_signature.matches?(hmac_request.mac_signature)
            #signature did not match
            unless result
              Mach.config.logger.error("signature does not match for mac_id=#{hmac_request.mac_id}, normalized_string=#{data.inspect}")
            end
            result
          else
            Mach.config.logger.error("unable to locate secret for mac_id=#{hmac_request.mac_id}")
            false
          end
        end

        private
        def credential_store
          Mach::configuration.credential_store
        end
      end
    end
  end
end
