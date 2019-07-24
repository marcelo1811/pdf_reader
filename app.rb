require 'sinatra/base'
require 'sinatra/activerecord'
require 'byebug'

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

class App < Sinatra::Base
  get '/' do
    erb :index
  end
end
