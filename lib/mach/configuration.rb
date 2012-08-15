require 'mach/validation/strategy/in_memory_keys'
require 'mach/persistence/in_memory_store'
require 'base64'

module Mach
  class Configuration
    attr_accessor :signature_validation_strategy, :stale_request_window, :data_store

    def initialize
      @signature_validation_strategy = Mach::Validation::Strategy::InMemoryKeys.configure({})
      @stale_request_window = 10
      @data_store = Mach::Persistence::InMemoryStore.new
    end
  end
end
