#\ -p 9595
require 'bundler/setup'
require 'sinatra/base'
require 'mach'
require 'securerandom'
require 'openssl'
require 'base64'
require 'multi_json'

@@credential_store = {}

class App < Sinatra::Base
  get '/credentials' do
    content_type 'application/json'
    credentials = CredentialsGenerator.generate_id_secret_pair
    @@credential_store[credentials[:id]] = credentials[:secret]
    MultiJson.encode(credentials)
  end

  get '/secret' do
    MultiJson.encode({:id => params[:id], :secret => @@credential_store[params[:id]]})
  end
end


class CredentialsGenerator
  class << self
    def generate_id
      SecureRandom.base64(24).tr('+/=lIO0', 'pqrsxyz')
    end

    def generate_secret
      Base64.strict_encode64(OpenSSL::Cipher::Cipher.new('aes-256-cbc').random_key)
    end

    def generate_id_secret_pair
      id = generate_id
      secret = generate_secret
      {:id => id, :secret => secret}
    end
  end
end


run App.new
