require 'bundler/setup'
require 'sinatra/base'
require 'mach'

class App < Sinatra::Base
  get '/' do
    p "hello"
  end
end

run App.new
