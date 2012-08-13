require 'mach/normalized_string'
require 'mach/signature'

module Mach
  #if ::Faraday.respond_to? :register_middleware
    #::Faraday.register_middleware :request, :hmac_authentication => lambda { Mach::Faraday::HmacAuthentication }
  #end

  #class << self
    #def signature_valid?(algorithm, base64_key, data, base64_expected_signature)
      #base64_actual_signature = signature_for(algorithm, base64_key, data)
      #base64_actual_signature == base64_expected_signature
    #end
  #end
end
