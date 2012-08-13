require 'securerandom'
require 'base64'

module Mach
  class Nonce
    class << self
      def for(timestamp)
        #17 byte string to make sure we don't get any padding after base64
        Base64.urlsafe_encode64("#{SecureRandom.random_bytes(17)}#{timestamp}")
      end
    end
  end
end
