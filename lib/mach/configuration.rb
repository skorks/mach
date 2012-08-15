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
      @test_mode = Mach::TestMode.new
    end

    def test_mode
      @test_mode ||= Mach::TestMode.new
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
