module Mach
  class Configuration
    attr_accessor :signature_validation_strategy, :stale_request_window, :data_store

    def initialize
      @signature_validation_strategy = Mach::Validation::Strategy::InMemoryKeys.configure("foo" => Base64.strict_encode64("bar"))
      @stale_request_window = 10
      @data_store = Mach::Persistence::InMemoryStore.new
    end
  end
end
