require 'faraday'
require 'mach/hmac'
require 'mach/authorization_header'

module Mach
  module Faraday
    class HmacAuthentication < ::Faraday::Middleware
      include Mach::HMAC
      KEY = "Authorization".freeze

      def initialize(app, id, key)
        @mac_id = id
        @mac_key = key
        super(app)
      end

      def call(env)
        unless env[:request_headers][KEY]
          env[:request_headers][KEY] = self.header(env)
        end
        @app.call(env)
      end

      def header(env)
        AuthorizationHeader.new(@mac_id, @mac_key,
                                :request_method => mac_request_method(request_method(env)),
                                :path => mac_path(path(env), query_string(env)),
                                :host => mac_host(host(env)),
                                :port => mac_port(port(env), scheme(env)),
                                :ext => mac_ext(ext(env))).to_s
      end

      private
      def request_method(env)
        env[:request_method]
      end

      def host(env)
        env[:url].host
      end

      def port(env)
        env[:url].port
      end

      def path(env)
        env[:url].path
      end

      def query_string(env)
        env[:url].query
      end

      def ext(env)
        nil
      end

      def scheme(env)
        env[:url].scheme
      end
    end
  end
end
