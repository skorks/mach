module Mach
  module Validation
    module Strategy
      class Base
        class << self
          def configure(options = {})
            self.new(options)
          end
        end

        def verify(credential_id, request_signature, data)
          raise "Implement me"
        end
      end
    end
  end
end
