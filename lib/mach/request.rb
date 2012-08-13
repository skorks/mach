module Mach
  class Request < ::Rack::Request
    def authorization
      @env['HTTP_AUTHORIZATION']
    end

    def mac_authorization?
      self.authorization =~ /^\s*MAC .*$/
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

    def mac_path
      "#{path}?#{query_string}"
    end

    def mac_port
      port = self.port
      unless port
        port = 80 if self.scheme == 'http'
        port = 443 if self.scheme == 'https'
      end
      port
    end

    def mac_normalized_request_string
      if mac_authorization?
        NormalizedString.new(:timestamp => mac_timestamp,
                             :nonce => mac_nonce,
                             :request_method => request_method,
                             :path => mac_path,
                             :host => host,
                             :port => mac_port
                            ).to_s
      else
        ""
      end
    end
  end
end
