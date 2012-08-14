require 'securerandom'
require 'base64'

module Mach
  class Nonce
    class << self
      def for(timestamp)
        #17 byte string to make sure we don't get any padding after base64
        Base64.urlsafe_encode64("#{SecureRandom.random_bytes(17)}#{timestamp}")
      end

      def exists?(credential_id, nonce_value)
        Mach.configuration.data_store.find_nonce_by(credential_id, nonce_value)
      end

      def persist(credential_id, nonce_value, timestamp)
        Mach.configuration.data_store.add_nonce(credential_id, nonce_value, timestamp)
      end
    end
  end
end
