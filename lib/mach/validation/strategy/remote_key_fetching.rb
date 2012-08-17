require 'mach/signature'
require 'faraday'
require 'multi_json'

module Mach
  module Validation
    module Strategy
      class RemoteKeyFetching
        class << self
          def configure(base_url, path, id_param_name)
            self.new(base_url, path, id_param_name)
          end
        end

        def initialize(base_url, path, id_param_name)
          @base_url = base_url
          @path = path
          @id_param_name = id_param_name
        end

        def verify(credential_id, request_signature, data)
          begin
            credentials = fetch_credentials(credential_id)
          rescue Mach::Error::CredentialFetchingError => e
            #TODO possibly log something here
            #p "error fetching credentials"
            credentials = {"secret" => ""} # this should cause the validation to fail
          end
          Mach::Signature.new(credentials["secret"], data).matches?(request_signature)
        end

        private
        def fetch_credentials(credential_id)
          connection = ::Faraday.new(:url => @base_url) do |c|
            c.adapter ::Faraday.default_adapter
          end

          credentials_response = fetch_with_error_handling(credential_id) do |credential_id|
            connection.get { |req| req.url @path, @id_param_name.to_sym => credential_id }
          end

          credentials = decode_with_error_handling(credentials_response.body) do |json_string|
            MultiJson.decode(json_string)
          end
        end

        def fetch_with_error_handling(credential_id, &block)
          #TODO need to handle connection errors and invalid responses here
          begin
            credentials_response = block.call(credential_id)
          rescue Faraday::Error::ConnectionFailed => e
            #p "connection failed"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          rescue Faraday::Error::ResourceNotFound => e
            #p "resource not found"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          rescue Faraday::Error::TimeoutError => e
            #p "timeout error"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          rescue Faraday::Error::ParsingError => e
            #p "parsing error"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          rescue Faraday::Error::MissingDependency => e
            #p "missing dependency"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          rescue StandardError => e
            #p "unknown error"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          end
        end

        def decode_with_error_handling(json_string, &block)
          #TODO need to handle json decoding errors here
          begin
            block.call(json_string)
          rescue StandardError => e
            #p "json parsing error"
            #log something or something like that
            raise Mach::Error::CredentialFetchingError
          end
        end
      end
    end
  end
end
