require 'mach/persistence/in_memory_store'
require 'mach/persistence/redis_store'
require 'base64'
require 'logger'

module Mach
  class Configuration

    attr_reader :credential_store, :data_store, :stale_request_window, :ignore_validation_failure, :logger

    def initialize
      @stale_request_window = 10
      @data_store = Mach::Persistence::InMemoryStore.configure({})
      @credential_store = Hash.new
      @ignore_validation_failure = false
      @logger = ::Logger.new(STDOUT)
    end

    def with_credential_store(store, options = {})
      @credential_store = store
    end

    def with_data_store(store_identifier, options = {})
      store_class = Mach::Persistence.const_get(camelize("#{store_identifier.to_s}_store"))
      @data_store = store_class.configure(options)
    end

    def with_stale_request_window(num_seconds)
      @stale_request_window = num_seconds
    end

    def with_logger(logger)
      @logger = logger
    end

    def ignore_validation_failure!
      @ignore_validation_failure = true
    end

    private
    def camelize(string)
      string.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
    end
  end
end
