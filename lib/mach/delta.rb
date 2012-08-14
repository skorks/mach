module Mach
  class Delta
    class << self
      def present_for(credential_id)
        Mach.configuration.data_store.find_delta_by(credential_id)
      end

      def create(credential_id, server_timestamp, client_timestamp)
        delta_value = server_timestamp - client_timestamp
        expires_in = Mach.configuration.stale_request_window
        Mach.configuration.data_store.add_delta(credential_id, delta_value, expires_in)
      end
    end
  end
end
