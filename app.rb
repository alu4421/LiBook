#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
require 'data_mapper'
require 'omniauth-oauth2'      
require 'omniauth-google-oauth2'
require 'omniauth-twitter'
require 'omniauth-facebook'
require 'xmlsimple'
require 'restclient'

#Database Configuration
  configure :development, :test do
    DataMapper.setup( :default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/main.db" )
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  DataMapper::Logger.new($stdout, :debug)
  DataMapper::Model.raise_on_save_failure = true 

  require_relative 'model'

  DataMapper.finalize

  #DataMapper.auto_migrate!
  DataMapper.auto_upgrade! #No delete information, update
#End Database Configuration

Base = 36 #base alfanumerica 36, no contiene la ñ para la ñ incorporar la base 64.

#User Control
  use OmniAuth::Builder do       
    config = YAML.load_file 'config/config.yml'
    provider :google_oauth2, config['identifier'], config['secret']
    provider :twitter, config['identifier_twitter'], config['secret_twitter'] 
  end
    
  enable :sessions               
  set :session_secret, '*&(^#234a)'
#End User Control

get '/' do
  if session[:auth] then
    haml :principal
  else
    haml :index
  end
end

get '/ejemplo' do
  haml :ejemplo
end

get '/escanear' do
  haml :escaner
end

get '/info' do
  haml :info
end

post '/data' do
  File.open('img/escaner/data.jpeg','wb') {|file| file.write request.body.read }
  "Result: photo saved!"
end

#Redirect
get '/auth/:name/callback' do
    session[:auth] = @auth = request.env['omniauth.auth']
    session[:email] = @auth['info'].email
    session[:nombre] = @auth['info'].name
    redirect '/'
end

post '/insertar' do
  json = RestClient.get "https://www.googleapis.com/books/v1/volumes?q=isbn:#{params[:url]}"
  obj = JSON.parse(json)
  
  "hola"
end

get '/sign_google/?' do
  redirect '/auth/google_oauth2'
end

get '/sign_twitter/?' do 
  redirect '/auth/twitter'
end

get '/logout' do
  session.clear
  redirect '/'
end

