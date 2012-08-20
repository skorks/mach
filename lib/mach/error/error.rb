module Mach
  module Error
    class RequestNotMacAuthenticatedError < StandardError
    end
    class CredentialFetchingError < StandardError
    end
    class MissingConfigurationOptionError < StandardError
    end
  end
end
