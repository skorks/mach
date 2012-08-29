require 'mach/validation/strategy/in_memory'
require 'mach/validation/strategy/remote_key'
require 'mach/persistence/in_memory_store'
require 'mach/persistence/redis_store'
require 'base64'

module Mach
  class Configuration
    #attr_accessor :signature_validation_strategy, :stale_request_window, :data_store

    attr_reader :credential_store, :data_store, :stale_request_window, :test_mode # do we need this?

    def initialize
      @signature_validation_strategy = Mach::Validation::Strategy::InMemory.configure({})
      @stale_request_window = 10
      @data_store = Mach::Persistence::InMemoryStore.configure({})
      @credential_store = CredentialStore::Adapter::Redis.new({})
      @test_mode = Mach::TestMode.new
    end

    def with_credential_store(store, options = {})
      @credential_store = store
      #store_class = CredentialStore::Adapter.const_get(camelize(store_type.to_s))
      #@credential_store = store_class.new(options)
      # find out if we should use redis store first
      #@credential_store = CredentialStore::Adapter::Redis.new() #todo pass options
    end

    def signature_validation_strategy(strategy_identifier = nil, options = {})
      if strategy_identifier.nil? && (options.nil? || options.keys.count == 0)
        #we're accessing
        @signature_validation_strategy
      else
        #we're configuring
        strategy_class = Mach::Validation::Strategy.const_get(camelize(strategy_identifier.to_s))
        @signature_validation_strategy = strategy_class.configure(options)
      end
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

  class TestMode
    attr_accessor :active, :fake_timestamp, :fake_nonce, :suspicious_nonce

    def initialize
      @active = false
      @fake_timestamp = nil
      @fake_nonce = nil
      @suspicious_nonce = nil
    end
  end
end
