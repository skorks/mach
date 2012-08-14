require 'mach/signature'

module Mach
  module Validation
    class SignatureValidator
      class << self
        def valid?(hmac_request, base64_key = nil)
          data = hmac_request.mac_normalized_request_string
          #if the key is not nil we can short-circuit the validation
          if base64_key
            Mach::Signature.new(base64_key, data).matches?(hmac_request.mac_signature)
          else
            validation_strategy = Mach.configuration.signature_validation_strategy.new(hmac_request.mac_id, hmac_request.mac_signature, data)
            validation_strategy.verify
          end
        end
      end
    end
  end
end
