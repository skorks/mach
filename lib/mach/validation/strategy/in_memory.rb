require 'mach/validation/strategy/base'
require 'mach/signature'

module Mach
  module Validation
    module Strategy
      class InMemory < Base
        def initialize(credentials = {})
          @credentials = credentials
        end

        def verify(credential_id, request_signature, data)
          key = @credentials[credential_id]
          Mach::Signature.new(key, data).matches?(request_signature)
        end
      end
    end
  end
end
