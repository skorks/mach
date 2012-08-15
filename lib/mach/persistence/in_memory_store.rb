require 'mach/persistence/delta_and_nonce_store'
require 'mach/timestamp'

module Mach
  module Persistence
    class InMemoryStore < Mach::Persistence::DeltaAndNonceStore
      def initialize
        @deltas = {}
        @nonces = {}
      end

      def find_delta_by(credential_id)
        delta_hash = @deltas[credential_id] || {}
        now = Timestamp.now
        if delta_hash[:expires_at] && delta_hash[:expires_at] > now
          delta_hash[:delta_value]
        else
          @deltas[credential_id] = nil
          nil
        end
      end

      def add_delta(credential_id, delta_value, expires_in)
        expires_at = Timestamp.now + expires_in
        @deltas[credential_id] = {:delta_value => delta_value, :expires_at => expires_at}
        @deltas[credential_id][:delta_value]
      end

      def find_nonce_by(credential_id, nonce_value)
        nonces_for_credential_id = @nonces[credential_id] || {}
        expires_at = nonce_value = nonces_for_credential_id[nonce_value]
        now = Timestamp.now
        if nonce_value && expires_at > now
          nonce_value
        else
          nonces_for_credential_id[nonce_value] = nil
          nil
        end
      end

      def add_nonce(credential_id, nonce_value, expires_in)
        expires_at = Timestamp.now + expires_in
        @nonces[credential_id] ||= {}
        @nonces[credential_id][nonce_value] = expires_at
      end
    end
  end
end
