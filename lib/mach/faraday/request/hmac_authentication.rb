require 'faraday'

module Mach
  module Faraday
    class HmacAuthentication < ::Faraday::Middleware
      KEY = "Authorization".freeze

      def initialize(app, id, key)
        @mac_id = id
        @mac_key = key
        @auth_type = "MAC"
        super(app)
      end

      def call(env)
        unless env[:request_headers][KEY]
          env[:request_headers][KEY] = self.header(env)
        end
        @app.call(env)
      end

      def header(env)
        "#{@auth_type} #{mac_auth_value(env)}".tap do |a|
          p a
        end
      end

      private
      def mac_auth_value(env)
        AuthorizationHeader.new(id, key).to_s
        #timestamp = HMAC::Timestamp.now
        #nonce = HMAC::Nonce.for(timestamp)
        #mac = sign_normalized_string(env, timestamp, nonce)
        #"id=\"#{@mac_id}\",ts=\"#{timestamp}\",nonce=\"#{nonce}\",mac=\"#{mac}\""
      end

      def sign_normalized_string(env, timestamp, nonce)
        normalized_string = NormalizedString.new(:timestamp => timestamp,
                             :nonce => nonce,
                             :request_method => mac_request_method(env),
                             :path => mac_path(env),
                             :host => mac_host(env),
                             :port => mac_port(env)
                            )
        signed_string = HMAC.signature_for("hmac-sha-256", @mac_key, normalized_string.to_s)
      end

      def mac_request_method(env)
        env[:request_method].to_s.upcase
      end

      def mac_host(env)
        url = env[:url]
        url.host
      end

      def mac_port(env)
        url = env[:url]
        port = url.port
        unless port
          port = 80 if url.scheme == 'http'
          port = 443 if url.scheme == 'https'
        end
        port
      end

      def mac_path(env)
        url = env[:url]
        "#{url.path}?#{url.query}"
      end
    end
  end
end
