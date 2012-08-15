require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'

MAC_ID = "abc"
MAC_KEY = Base64.strict_encode64("123")

Mach.configuration do |configuration|
  configuration.signature_validation_strategy = Mach::Validation::Strategy::InMemoryKeys.configure(MAC_ID => MAC_KEY)
  configuration.stale_request_window = 10
  configuration.data_store = Mach::Persistence::InMemoryStore.new
end

class App < Sinatra::Base
  get '/' do
    p (Mach::RequestValidator.valid?(request)) ? "Request is valid" : "Request is not valid"
  end
end

run App.new
