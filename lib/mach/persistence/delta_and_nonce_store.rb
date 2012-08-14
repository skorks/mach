module Mach
  module Persistence
    class DeltaAndNonceStore
      def find_delta_by(credential_id)
        raise "Implement me"
      end

      def add_delta(credential_id, delta_value, expires_in)
        raise "Implement me"
      end

      def find_nonce_by(credential_id, nonce_value)
        raise "Implement me"
      end

      def add_nonce(credential_id, nonce_value, timestamp)
        raise "Implement me"
      end
    end
  end
end
