#!/usr/bin/env ruby
require 'bundler/setup'
require 'mach'
require 'multi_json'
require 'optparse'
require 'date'

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

def make_request_with_given_credentials(url, id, secret)
  connection = Faraday.new(:url => url) do |c|
    c.request :hmac_authentication, id, secret
    c.adapter Faraday.default_adapter
  end
  res = connection.get
  p [res.status, res.body]
  [res.status, res.body]
end

options = {:id => "x", :secret => "y"}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: client [OPTIONS]"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-i ID", "--id ID", String, "the mac id") do |id|
    options[:id] = id
  end

  opt.on("-d SECRET","--secret SECRET", String, "the mac secret") do |secret|
    options[:secret] = secret
  end

  opt.on("-u URL","--url URL", String, "the url to hit") do |url|
    options[:url] = url
  end

  opt.on("-g", "--good", "a valid request getting credentials from the credential store") do
    options[:good] = true
  end

  opt.on("-b", "--bad", "an invalid request getting credentials from the credential store") do
    options[:bad] = true
  end

  opt.on_tail("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

if options[:good]
  make_valid_request
elsif options[:bad]
  make_invalid_request
else
  raise "You need to supply an id and a secret" unless options[:id] && options[:secret]
  raise "You need to supply a url to hit" unless options[:url]
  options[:secret] = Base64.strict_encode64(options[:secret])
  p options
  make_request_with_given_credentials(options[:url], options[:id], options[:secret])
end
