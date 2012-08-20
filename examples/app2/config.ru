require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'

#MAC_ID = "abc"
#MAC_KEY = Base64.strict_encode64("123")

Mach.configuration do |config|
  config.signature_validation_strategy :remote_key, :url => "http://localhost:9595/secret?id=%s"
  config.stale_request_window 10
  config.data_store :redis, :host => "localhost", :port => "6379"
end

class App < Sinatra::Base
  get '/' do
    p (Mach::RequestValidator.valid?(request)) ? "Request is valid" : "Request is not valid"
  end
end

run App.new
