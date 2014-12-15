# -*- coding: utf-8 -*-
# require 'coveralls'
# Coveralls.wear!

ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'
require 'selenium-webdriver'

include Rack::Test::Methods


def app
  Sinatra::Application
end

describe "Tests de la pagina raiz ('/') con metodo get" do
  it "Carga de la web desde el servidor" do
  get '/'
    assert last_response.ok?
  end

  it "El titulo deberia de ser" do
    get '/'
    assert_match "<title>LiBook</title>", last_response.body
  end

  it "Titulo de bienvenida" do
    get '/'
    assert last_response.body.include?("Bienvenido a LiBook")
  end

  it "Registro" do
    get '/'
    assert last_response.body.include?("Regístrese")
    assert last_response.body.include?("/img/ico/googleplus.ico")
    assert last_response.body.include?("/img/ico/facebook.ico")
    assert last_response.body.include?("/img/ico/twitter.ico")
  end

  it "Redes sociales" do
    get '/'
    assert last_response.body.include?("Úsalo con tus redes sociales Facebook y Twitter")
  end

  # it "El foot deberia de contener" do
  #   get '/'
  #   assert_match %Q{<p class='pull-right'>Leinah ©Copyright 2014    </p>}, last_response.body
  # end

end

# Selenium Tests
describe "Contenido de la web" do

  before :all do
    @browser = Selenium::WebDriver.for :firefox
    @web_local = 'http://localhost:9292/'
    @web = 'http://libook.herokuapp.com/' #Revisar por si no es está la dirección en Heroku
    @browser.get(@web_local) #Cambiar por @web cuando esté en Heroku
      @browser.manage.timeouts.implicit_wait = 5
  end

  after :all do
    @browser.quit
  end

  it "Carga de la web" do
    assert_equal(@web_local, @browser.current_url)
  end

end

# Rack Tests
# describe "Contenido de la web" do
#
#
# end
