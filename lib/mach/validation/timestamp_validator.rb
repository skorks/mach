require 'mach/timestamp'
require 'mach/delta'

module Mach
  module Validation
    class TimestampValidator
      class << self
        def valid?(hmac_request)
          server_timestamp = Mach::Timestamp.now.to_i
          client_timestamp = hmac_request.mac_timestamp.to_i
          delta = Mach::Delta.present_for(hmac_request.mac_id) #do we have a delta for this client
          unless delta
            delta = Mach::Delta.create(hmac_request.mac_id, server_timestamp, client_timestamp)
          end
          #make sure the client timestamp is not older than what we're willing to accept
          server_timestamp - (client_timestamp + delta.to_i) < Mach.configuration.stale_request_window
        end
      end
    end
  end
end
