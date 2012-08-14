require 'mach/faraday/request/hmac_authentication'

module Mach
  if ::Faraday.respond_to? :register_middleware
    ::Faraday.register_middleware :request, :hmac_authentication => lambda { Mach::Faraday::HmacAuthentication }
  end
  class << self
    def configuration
      @configuration ||= Mach::Configuration.new
    end
  end
end
