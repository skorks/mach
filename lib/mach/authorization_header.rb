require 'mach/timestamp'
require 'mach/nonce'
require 'mach/normalized_string'
require 'mach/signature'

module Mach
  class AuthorizationHeader
    def initialize(id, key, options = {})
      @id = id
      @key = key
      @options = options
    end

    def to_s
      "MAC #{build_auth_value}"
    end

    private

    def build_auth_value
      timestamp = create_timestamp
      nonce = create_nonce_for(timestamp)
      normalized_string = NormalizedString.new(:timestamp => timestamp,
                                               :nonce => nonce,
                                               :request_method => @options[:request_method],
                                               :path => @options[:path],
                                               :host => @options[:host],
                                               :port => @options[:port]
                                              )
      mac = Mach::Signature.new(@key, normalized_string.to_s)  #sign_normalized_string(env, timestamp, nonce)
      "id=\"#{@id}\",ts=\"#{timestamp}\",nonce=\"#{nonce_for_header(nonce)}\",mac=\"#{mac}\""
    end

    def create_timestamp
      Mach::Timestamp.now
    end

    def create_nonce_for(timestamp)
      Mach::Nonce.for(timestamp)
    end

    def nonce_for_header(actual_nonce)
      actual_nonce
    end
  end
end
