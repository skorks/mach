require 'mach/signature'

module Mach
  module Validation
    
    class SignatureValidator
      class << self
        def valid?(hmac_request)
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
