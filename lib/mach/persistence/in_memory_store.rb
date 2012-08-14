module Mach
  module Persistence
    class InMemoryStore < Mach::Persistence::DeltaAndNonceStore
      def initialize
        @deltas = {}
        @nonces = {}
      end

      def find_delta_by(credential_id)
        @deltas[credential_id]
      end

      def add_delta(credential_id, delta_value, expires_in)
        @deltas[credential_id] = delta_value
      end

      def find_nonce_by(credential_id, nonce_value)
        nonces_for_credential_id = @nonces[credential_id] || {}
        nonces_for_credential_id[nonce_value]
      end

      def add_nonce(credential_id, nonce_value, timestamp)
        @nonces[credential_id] ||= {}
        @nonces[credential_id][nonce_value] = timestamp
      end
    end
  end
end
