module Mach
  module HMAC
    def mac_request_method(request_method)
      request_method.to_s.upcase
    end

    def mac_path(path, query_string)
      "#{path}?#{query_string}"
    end

    def mac_host(host)
      host
    end

    def mac_port(port, scheme)
      unless port
        port = 80 if scheme == 'http'
        port = 443 if scheme == 'https'
      end
      port
    end

    def mac_ext(ext)
      ext
    end
  end
end
