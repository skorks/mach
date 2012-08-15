require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'

MAC_ID = "abc"
MAC_KEY = Base64.strict_encode64("123")

class App < Sinatra::Base
  get '/' do
    connection = Faraday.new(:url => "http://localhost:9494") do |c|
      c.request :hmac_authentication, MAC_ID, MAC_KEY
      c.adapter Faraday.default_adapter
    end
    response = connection.get do |req|
      req.url '/'
    end
  end
end

run App.new
