module Mach
  module Validation
    class NonceValidator
      class << self
        def valid?(hmac_request)
          !Nonce.exists?(hmac_request.mac_nonce)
        end
      end
    end
  end
end
