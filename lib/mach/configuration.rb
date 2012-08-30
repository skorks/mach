require 'mach/persistence/in_memory_store'
require 'mach/persistence/redis_store'
require 'base64'

module Mach
  class Configuration

    attr_reader :credential_store, :data_store, :stale_request_window

    def initialize
      @stale_request_window = 10
      @data_store = Mach::Persistence::InMemoryStore.configure({})
      @credential_store = Hash.new
    end

    def with_credential_store(store, options = {})
      @credential_store = store
      #store_class = CredentialStore::Adapter.const_get(camelize(store_type.to_s))
      #@credential_store = store_class.new(options)
      # find out if we should use redis store first
      #@credential_store = CredentialStore::Adapter::Redis.new() #todo pass options
    end

    def with_data_store(store_identifier, options = {})
      store_class = Mach::Persistence.const_get(camelize("#{store_identifier.to_s}_store"))
      @data_store = store_class.configure(options)
    end

    def with_stale_request_window(num_seconds)
      @stale_request_window = num_seconds
    end

    private
    def camelize(string)
      string.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
    end
  end
end
