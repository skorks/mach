#!/usr/bin/env ruby
require 'bundler/setup'
require 'mach'
require 'base64'
require 'multi_json'

def get_credentials
  connection = Faraday.new(:url => "http://localhost:9595") do |c|
    c.adapter Faraday.default_adapter
  end
  credentials_response = connection.post { |req| req.url "/credentials" } # first request is to store the client delta
  credentials = MultiJson.decode(credentials_response.body)
end

def validating_server
  @validating_server ||= ENV['VALIDATING_SERVER'] || "http://localhost:9494"
end

def make_request(id, secret)
  #make a request using those credentials
  connection = Faraday.new(:url => validating_server) do |c|
    c.request :hmac_authentication, id, secret
    c.adapter Faraday.default_adapter
  end
  res = connection.get { |req| req.url '/' }
  [res.status, res.body]
end

def make_valid_request
  credentials = get_credentials
  make_request(credentials["id"], credentials["secret"])
end

def make_invalid_request
  credentials = get_credentials
  make_request(credentials["id"], "XXX")
end

p make_valid_request
p make_invalid_request
