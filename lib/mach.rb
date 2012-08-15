require 'mach/faraday/request/hmac_authentication'
require 'mach/configuration'
require 'mach/validation/request_validator'

module Mach
  if ::Faraday.respond_to? :register_middleware
    ::Faraday.register_middleware :request, :hmac_authentication => lambda { Mach::Faraday::HmacAuthentication }
  end
  class << self
    def configuration(&block)
      @configuration ||= Mach::Configuration.new
      if block_given?
        block.call(@configuration)
      else
        @configuration
      end
    end
  end
end
