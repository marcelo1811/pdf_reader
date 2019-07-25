require 'sinatra/base'
require 'sinatra/activerecord'
require 'open-uri'
require 'pdf-reader'
require 'byebug'
require 'csv'
require './services/csv_service.rb'

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

class App < Sinatra::Base
  include CsvService

  get '/' do
    erb :index
  end

  post '/file_upload' do
    filename = params[:file][:filename].gsub('.pdf', '')
    file = params[:file][:tempfile]

    content_type 'application/csv'
    attachment "#{filename}.csv"
    CsvService.convert_to_csv(file)
  end
end
