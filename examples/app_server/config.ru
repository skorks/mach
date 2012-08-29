require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'
require 'credential_store'
require 'pry'

#MAC_ID = "abc"
#MAC_KEY = Base64.strict_encode64("123")

Mach.configuration do |config|
  #config.with_credential_store :credential_server, :server => "http://localhost:9595/secret/:id"
  #config.with_credential_store :redis, :host => "localhost", :port => "6379"
  config.with_credential_store CredentialStore::Adapter::CredentialServer.new(:server => 'http://localhost:9595/')
  config.with_stale_request_window 10
  config.with_data_store :redis, :host => "localhost", :port => "6379"
end

class App < Sinatra::Base
  get '/' do
    p (Mach::RequestValidator.valid?(request)) ? "Request is valid" : "Request is not valid"
  end
end

run App.new
