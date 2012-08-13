module Mach
  class NormalizedString
    def initialize(options = {})
      @timestamp = options[:timestamp]
      @nonce = options[:nonce]
      @request_method = options[:request_method]
      @path = options[:path]
      @host = options[:host]
      @port = options[:port]
      @ext = options[:ext] || "\n"
    end

    def to_s
      [@timestamp, @nonce, @request_method, @path, @host, @port, @ext].join("\n")
    end
  end
end
