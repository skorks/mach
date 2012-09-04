#!/usr/bin/env ruby
require 'bundler/setup'
require 'mach'
require 'multi_json'

def credentials
  @credentials ||= (
    env_credentials ||
    lambda {
      connection = Faraday.new(:url => creds_server) do |c|
        c.adapter Faraday.default_adapter
      end
      credentials_response = connection.post { |req| req.url "/credentials" } # first request is to store the client delta
      MultiJson.decode(credentials_response.body)
    }.call
  ).tap { |credentials| puts "Using credentials: #{credentials.inspect}" }
end

def env_credentials
  @env_credentials ||= ENV['CREDENTIALS'] && Hash[%w{id secret}.zip(ENV['CREDENTIALS'].split(":"))]
end

def creds_server
  @creds_server ||= ENV['CREDS_SERVER'] || "http://localhost:9090"
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
  make_request(credentials["id"], credentials["secret"])
end

def make_invalid_request
  make_request(credentials["id"], "XXX")
end

p make_valid_request
p make_invalid_request
