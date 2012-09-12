require 'mach/error/error'
require 'mach/persistence/delta_and_nonce_store'
require 'mach/timestamp'
require 'redis'

module Mach
  module Persistence
    class RedisStore < Mach::Persistence::DeltaAndNonceStore
      def initialize(options = {})
        raise Mach::Error::MissingConfigurationOptionError unless options[:host] && options[:port]
        @redis = Redis.new(:host => options[:host], :port => options[:port])
      end

      def find_delta_by(credential_id)
        @redis.get(delta_key_for(credential_id))
      end

      def add_delta(credential_id, delta_value, expires_in)
        @redis.setex(delta_key_for(credential_id), expires_in, delta_value)
        delta_value
      end

      def find_nonce_by(credential_id, nonce_value)
        @redis.get(nonce_key_for(credential_id, nonce_value))
      end

      def add_nonce(credential_id, nonce_value, expires_in)
        @redis.setex(nonce_key_for(credential_id, nonce_value), expires_in, 1)
      end

      private
      def delta_key_for(credential_id)
        "delta_key_for_#{credential_id}"
      end

      def nonce_key_for(credential_id, nonce)
        "nonce_key_for_#{credential_id}_#{nonce}"
      end
    end
  end
end
