#!/usr/bin/env ruby
require 'bundler/setup'
require 'mach'
require 'base64'
require 'multi_json'

MAC_ID  = ENV['MAC_ID' ] || "abc"
MAC_KEY = ENV['MAC_KEY'] || Base64.strict_encode64("123")

Mach.configuration do |configuration|
  #configuration.test_mode.active = true  # undefined method `test_mode' for #<Mach::Configuration
end

=begin
require 'sinatra/base'
class App < Sinatra::Base
  before do
    @connection = Faraday.new(:url => "http://localhost:9494") do |c|
      c.request :hmac_authentication, MAC_ID, MAC_KEY
      c.adapter Faraday.default_adapter
    end
  end

  get '/basic' do
    @connection.get { |req| req.url '/' }
  end

  get '/stale' do
    Mach.configuration.test_mode.fake_timestamp = nil # next request should not be stale
    @connection.get { |req| req.url '/' } # first request is to store the client delta
    Mach.configuration.test_mode.fake_timestamp = Time.now.utc.to_i - 100000 # now next request will be stale
    @connection.get { |req| req.url '/' } # first request is to store the client delta
    Mach.configuration.test_mode.fake_timestamp = nil
  end

  get '/duplicate_nonce' do
    Mach.configuration.test_mode.fake_nonce = "abc123" #first request should be ok
    @connection.get { |req| req.url '/' }
    @connection.get { |req| req.url '/' } # this request should be rejected due to duplicate nonce
    Mach.configuration.test_mode.fake_nonce = nil
  end

  get '/suspicious_nonce' do
    Mach.configuration.test_mode.suspicious_nonce = "foobar"
    @connection.get { |req| req.url '/' } #request should fail due to signature validation
    Mach.configuration.test_mode.suspicious_nonce = nil
  end

  get '/with_credentials' do
  end
end

run App.new
=end

def with_credentials
    #get the credentials
    connection = Faraday.new(:url => "http://localhost:9595") do |c|
      c.adapter Faraday.default_adapter
    end
    credentials_response = connection.get { |req| req.url "/credentials" } # first request is to store the client delta
    credentials = MultiJson.decode(credentials_response.body)

    #make a request using those credentials
    connection = Faraday.new(:url => "http://localhost:9494") do |c|
      c.request :hmac_authentication, credentials["id"], credentials["secret"]
      c.adapter Faraday.default_adapter
    end
    connection.get { |req| req.url '/' }
end

with_credentials
