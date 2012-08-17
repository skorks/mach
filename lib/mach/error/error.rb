module Mach
  module Error
    class RequestNotMacAuthenticatedError < StandardError
    end
    class CredentialFetchingError < StandardError
    end
  end
end
