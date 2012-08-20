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
    alias :config :configuration # can use either config or configuration

    def respond_to?(method, include_private=false)
      self.configuration.respond_to?(method, include_private) || super
    end

    private

    def method_missing(method, *args, &block)
      return super unless self.configuration.respond_to?(method)
      self.configuration.send(method, *args, &block)
    end
  end
end
