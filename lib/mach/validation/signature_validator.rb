require 'mach/signature'

module Mach
  module Validation
    
    class OldSignatureValidator
      class << self
        def valid?(hmac_request, base64_key = nil)
          data = hmac_request.mac_normalized_request_string
          #if the key is not nil we can short-circuit the validation
          if base64_key
            Mach::Signature.new(base64_key, data).matches?(hmac_request.mac_signature)
          else
            Mach.configuration.signature_validation_strategy.verify(hmac_request.mac_id, hmac_request.mac_signature, data)
          end
        end
      end
    end

    class SignatureValidator
      class << self
        def valid?(hmac_request)
          binding.pry
          if secret = credential_store[hmac_request.mac_id]
            data = hmac_request.mac_normalized_request_string
            Mach::Signature.new(secret, data).matches?(hmac_request.mac_signature)
          else
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
