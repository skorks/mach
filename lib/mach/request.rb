require 'rack'
require 'mach/normalized_string'

module Mach
  class Request < ::Rack::Request
    include Mach::HMAC

    def authorization
      @env['HTTP_AUTHORIZATION']
    end

    def mac_authorization?
      !!(self.authorization =~ /^\s*MAC .*$/)
    end

    def mac_id
      self.authorization.scan(/^\s*MAC\s*.*id="(.*?)".*/).flatten[0]
    end

    def mac_timestamp
      self.authorization.scan(/^\s*MAC\s*.*ts="(.*?)".*/).flatten[0]
    end

    def mac_nonce
      self.authorization.scan(/^\s*MAC\s*.*nonce="(.*?)".*/).flatten[0]
    end

    def mac_ext
      self.authorization.scan(/^\s*MAC\s*.*ext="(.*?)".*/).flatten[0]
    end

    def mac_signature
      self.authorization.scan(/^\s*MAC\s*.*mac="(.*?)".*/).flatten[0]
    end

    def mac_normalized_request_string
      if mac_authorization?
        NormalizedString.new(:timestamp => mac_timestamp,
                             :nonce => mac_nonce,
                             :request_method => request_method,
                             :path => mac_path(path, query_string),
                             :host => host,
                             :port => mac_port(self.port, self.scheme),
                             :ext => mac_ext
                            ).to_s
      else
        ""
      end
    end
  end
end
