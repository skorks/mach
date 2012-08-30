#\ -p 9494
require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'
require 'mach/rack/request_validator'
require 'credential_store'

#MAC_ID = "abc"
#MAC_KEY = Base64.strict_encode64("123")

Mach.configuration do |config|
  config.with_credential_store CredentialStore::Adapter::CredentialServer.new(:server => 'http://localhost:9595/')
  config.with_stale_request_window 10
  config.with_data_store :redis, :host => "localhost", :port => "6379"
end

class App < Sinatra::Base
  use Mach::Rack::RequestValidator

  get '/' do
    p (Mach::RequestValidator.valid?(request)) ? "Request is valid" : "Request is not valid"
    'OK'
  end
end

run App.new
