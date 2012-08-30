module Mach
  module Rack
    class RequestValidator
      def initialize app
        @app = app
      end

      def call env
        request = Mach::Request.new(env)
        if request.mac_authorization? && !Mach::RequestValidator.valid?(request)
          failure
        else
          success(env)
        end
      end

      private

      def success(env)
        @app.call(env)
      end

      def failure
        [401, { 'Content-Type' => 'application/json' }, ['Unauthorized'] ]
      end
    end
  end
end

