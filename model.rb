require 'restclient'
require 'xmlsimple'
require 'dm-core'
require 'dm-migrations'
require 'json'

class Biblioteca
  include DataMapper::Resource
	property :id, Serial
	property :titulo, Text
    property :autor, Text
	property :editorial, Text
	property :categoria, Text
    property :isbn, Text
    property :email, Text
    property :created_at, DateTime
end