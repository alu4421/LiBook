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
require 'json'

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
    @list = Biblioteca.all(:order => [ :id.asc ], :email => session[:email])
    haml :principal
  else
    haml :index
  end
end

get '/escanear' do
  haml :escaner
end

get '/info/:id' do
  @info = Biblioteca.all(:id => params[:id])
  haml :info
end

#pruebas
post '/data' do
  File.open('img/escaner/data.jpeg','wb') {|file| file.write request.body.read }
  "Result: photo saved!"
end
#fin

#Redirect
get '/auth/:name/callback' do
    session[:auth] = @auth = request.env['omniauth.auth']
    session[:email] = @auth['info'].email
    session[:nombre] = @auth['info'].name
    redirect '/'
end

post '/insertar' do
  json = RestClient.get "https://www.googleapis.com/books/v1/volumes?q=isbn:#{params[:isbn]}"
  
                              #no podemos trabajar con un JSOn
  my_hash = JSON.parse(json)  #lo convertimos a un hash
                              #tengamos ojo que item contiene un array de hash
  
  #Si la busqueda no ha dado ninguno por poco que sea devolvemos mensaje al usuario
  if my_hash["totalItems"] == 0  then
      redirect "/"
  end
  #Llegados a esta parte tenemos algun tipo de datos con el que trabajar

  arr_items = my_hash["items"] #Obtenemos un array con los Items

  re_hash = Hash.new          #creamos un nuevo hash
  re_hash = arr_items.first   #le metemos los datos que contiene item

  # en el nuevo array metemo la informacion el volumen
  arr_volumeInfo = re_hash['volumeInfo']
  
  #NOTA IMPORTANTE: Disponemos de una API de Google Books, no tenemos todos los datos
  #Y de los datos que nos dan, posiblemente no sean todos los que queramos.
  #Cuanto mas antiguo el libro, más dificil es encontrar datos más especificos
  #Asi que el siguiente codigo seran comprobaciones de los datos recibidos
  #Los datos que no nos proporcionen serán etiquedados con un "No Identificado"
  #Posteriormente se permitira al usario, si desea modificar ese campo.

  if arr_volumeInfo['imageLinks'] then
    #Nos quedamos con el primer enlace que corresponde a la imagen pequeña
    #el segundo enlace no nos interesa es la imagen un poco más grande
    img = arr_volumeInfo['imageLinks'].first
    img = img[1]
  else
    img = '/img/no_disponible.png'
  end
  if arr_volumeInfo['title'] then
    titulo = arr_volumeInfo['title']
  else
    titulo = "No Identificado"
  end
  if arr_volumeInfo['authors'] then
    # metemos los diferentes autores separados por "coma y espacio"
    autores = arr_volumeInfo['authors'] * ', ' 
  else
    autores = "No Identificado"
  end
  if arr_volumeInfo['publisher'] then
    editorial = arr_volumeInfo['publisher']
  else
    editorial = "No Identificado"
  end

  if arr_volumeInfo['categories'] then
    categoria = arr_volumeInfo['categories'] * ', '
  else
    categoria = "No Identificado"
  end

  if arr_volumeInfo['previewLink'] then
    url_google = arr_volumeInfo['previewLink']
  else
    url_google = "No Identificado"
  end

  if arr_volumeInfo['description'] then
    descripcion = arr_volumeInfo['description']
  else
    descripcion = "No Identificado"
  end

  if arr_volumeInfo['pageCount'] then
    npag = arr_volumeInfo['pageCount']
  else
    npag = "No Identificado"
  end

  if arr_volumeInfo['industryIdentifiers'] then
    #SI tiene los dos tipos de ISBN los ponemos
    if arr_volumeInfo['industryIdentifiers'].count == 2 then
      isbn10 = arr_volumeInfo['industryIdentifiers'].first
      isbn10 = isbn10['identifier']
      isbn13 = arr_volumeInfo['industryIdentifiers'][1]
      isbn13 = isbn13['identifier']
    end
    #SI por el contrario solo tiene uno
    if arr_volumeInfo['industryIdentifiers'].count == 1 then
      isbn = arr_volumeInfo['industryIdentifiers'].first
      isbn = isbn['type']
      #averiguamos que tipo de ISBN tiene y asignamos el valor correspondiente
      if isbn == "ISBN_10" then
          isbn10 = isbn['identifier']
          isbn13 = "No Identificado"
      elsif isbn == "ISBN_13"
        isbn13 = isbn['identifier']
        isbn10 = "No Identificado"
      end
    end
  else
    isbn10 = "No Identificado"
    isbn13 = "No Identificado"
  end

  if arr_volumeInfo['publishedDate'] then
      f_publicacion = arr_volumeInfo['publishedDate']
  else
      f_publicacion = "No Identificado"
  end

  if arr_volumeInfo['language'] then
      idioma = arr_volumeInfo['language']
      if idioma == "en" then
        idioma = "Inglés"
      elsif idioma == "es" then
        idioma = "Español"
      end
  else
      idioma = "No Identificado"
  end

  #insertarmos en la base de datos con la funcion first_or_create 
  @list = Biblioteca.first_or_create(:img => img, :titulo  => titulo, :autores => autores, :editorial => editorial, :categoria => categoria, :url_google => url_google, :isbn10 => isbn10, :isbn13 => isbn13, :descripcion => descripcion, :npag => npag, :f_publicacion => f_publicacion, :idioma => idioma, :email => session[:email] )
  
  redirect '/'
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

