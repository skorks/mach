s = <<-EOS
get '/with_credentials' do
   48     #get the credentials
    49     connection = Faraday.new(:url => "http://localhost:9595") do |c|
       50       c.adapter Faraday.default_adapter
        51     end
     52     credentials_response = connection.get { |req| req.url "/credentials" } # first request is to store the client delta
      53     credentials = MultiJson.decode(credentials_response.body)
       54 
        55     #make a request using those credentials
         56     connection = Faraday.new(:url => "http://localhost:9494") do |c|
            57       c.request :hmac_authentication, credentials["id"], credentials["secret"]
             58       c.adapter Faraday.default_adapter
              59     end
          60     connection.get { |req| req.url '/' }
           61   end
         end
    end
end

EOS

require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'base64'
require 'multi_json'



connection = Faraday.new(:url => "http://localhost:9595") do |c|
  c.adapter Faraday.default_adapter
end

credentials_response = connection.get { |req| req.url "/credentials" } # first request is to store the client delta
credentials = MultiJson.decode(credentials_response.body)

mac_id, mac_key = credentials['id'], credentials['secret']
mac_request_method = 'GET'
mac_path = '/'
mac_host = 'localhost'
mac_port = '9494'
mac_ext = ''

auth_header = Mach::AuthorizationHeader.new(
  mac_id, mac_key,
  {
  :request_method => mac_request_method,
  :path => mac_path, #, query_string,
  :host => mac_host,
  :port => mac_port, # scheme,
  :ext => mac_ext
  }
).to_s

puts auth_header

oauth_mac = 
puts "oauth-mac header: #{oauth_mac}"

