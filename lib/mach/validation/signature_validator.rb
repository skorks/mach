require 'mach/signature'
require 'logger'

module Mach
  module Validation
    
    class SignatureValidator
      class << self
        def valid?(hmac_request)
          debug_log(sprintf('request with mac_id: %s', hmac_request.mac_id))

          if secret = credential_store[hmac_request.mac_id]
            debug_log(sprintf('request found for mac_id: %s', hmac_request.mac_id))
            data = hmac_request.mac_normalized_request_string
            debug_log(sprintf('normalized request string: %s', hmac_request.normalized_request_string))
            signature = Mach::Signature.new(secret, data)
            result signature.matches?(hmac_request.mac_signature)
            debug_log(sprintf("sigature [generated]: %s signature[request] %s, matches?: %s",
                      signature.to_s, hmac_request.mac_signature, result))
            result
          else
            debug_log(sprintf('no secret found for mac_id: %s', hmac_request.mac_id))
            false
          end  
        end

        private
        def credential_store
          Mach::configuration.credential_store
        end

        def logger
          @log ||= Logger.new('mach_log.txt').tap { |l| l. debug "Log file created" }
        end

        def debug_log(msg)
          log.info msg
        end
      end
    end
  end
end

