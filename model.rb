require 'restclient'
require 'xmlsimple'
require 'dm-core'
require 'dm-migrations'
require 'json'

class Biblioteca
  include DataMapper::Resource
	property :id, Serial
	property :img, Text
	property :titulo, Text
    property :autores, Text
	property :editorial, Text
	property :categoria, Text
	property :isbn10, Text
    property :isbn13, Text
    property :npag, Text
    property :descripcion, Text
    property :url_google, Text
    property :f_publicacion, Text
    property :idioma, Text
    property :email, Text
    property :created_at, DateTime

end