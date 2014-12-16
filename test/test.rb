# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!

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
    @r_gl = 'http://localhost:9292/sign_google/'
    @r_gl1 = 'https://accounts.google.com/ServiceLogin?service=lso&passive=1209600&continue=https://accounts.google.com/o/oauth2/auth?scope%3Demail%2Bprofile%26response_type%3Dcode%26redirect_uri%3Dhttp://localhost:9292/auth/google_oauth2/callback%26access_type%3Doffline%26state%3D9a21786c6a12281ea4d1951858c84a8e64da84ea47d48cb6%26client_id%3D130257664242-4ubm1hg5sgpcu6bmlppon47dlmfo8vo2.apps.googleusercontent.com%26hl%3Des-ES%26from_login%3D1%26as%3D-70e344bf431d438b&ltmpl=popup&shdf=Cn4LEhF0aGlyZFBhcnR5TG9nb1VybBoADAsSFXRoaXJkUGFydHlEaXNwbGF5TmFtZRoPbGVpbmFoMTMtb2F1dGgyDAsSBmRvbWFpbhoPbGVpbmFoMTMtb2F1dGgyDAsSFXRoaXJkUGFydHlEaXNwbGF5VHlwZRoHREVGQVVMVAwSA2xzbyIUi7U7JDXhyezH2pISe2288yX5zK4oATIUiDMbwjbybQrKUJ3rBM7Uf418ULw&sarp=1&scc=1'
    @r_tw = 'http://localhost:9292/sign_twitter/'
    @r_fb = 'http://localhost:9292/#/'
    @r = 'ok'
    @esc = 'http://localhost:9292/escanear'
    @haniel = 'http://alu4421.github.io/'
    @karen = 'http://alu0100402001.github.io/'
    @jonay = 'http://alu0100600674.github.io/'
    @browser.get(@web_local) #Cambiar por @web cuando esté en Heroku
      @browser.manage.timeouts.implicit_wait = 5
  end

  after :all do
    @browser.quit
  end

  it "Carga de la web" do
    assert_equal(@web_local, @browser.current_url)
  end

  it "Mensaje de bienvenida" do
    titulo = @browser.find_element(:tag_name, "h1").text
	  assert_equal("Bienvenido a LiBook", titulo)
  end

  it "Invitación a usar Libook" do
    titulo2 = @browser.find_element(:tag_name, "h2").text
    assert_equal("Si estás cansado de no encontrar un libro en tu inmensa biblioteca, no esperes mas y únete al gestor de libros Libook.", titulo2)
  end

  it "Registro con Google" do
    gl = @browser.find_element(:id, "google-auth").click
    assert_equal(@r, gl)
    #assert_equal(@r_gl1, @browser.current_url)
  end

  it "Registro con Facebook" do
    fb = @browser.find_element(:id, "facebook-auth").click
    assert_equal(@r, fb)
    #assert_equal(@r_fb, @browser.current_url)
  end

  it "Registro con Twitter" do
    tw = @browser.find_element(:id, "twitter-auth").click
    assert_equal(@r, tw)
    #assert_equal(@r_gl1, @browser.current_url)
  end

  it "Link a la página principal" do
    index = @browser.find_element(:id, "btn-inicio").click
    assert_equal(@r, index)
    assert_equal(@web_local, @browser.current_url)
  end

  # it "Página de Haniel" do
  #   h = @browser.find_element(:id, "btn-haniel").click
  #   assert_equal(@r, h)
  #   assert_equal(@haniel, @browser.current_url)
  # end
  #
  # it "Página de Karen" do
  #   k = @browser.find_element(:id, "btn-karen").click
  #   assert_equal(@r, k)
  #   assert_equal(@karen, @browser.current_url)
  # end
  #
  # it "Página de Jonay" do
  #   j = @browser.find_element(:id, "btn-jonay").click
  #   assert_equal(@r, j)
  #   assert_equal(@jonay, @browser.current_url)
  # end

  # it "Acceso a la función escanear" do
  #   esc = @browser.find_element(:id, "btn-escanear").click
  #   assert_equal(@r, esc)
  #   assert_equal(@esc, @browser.current_url)
  # end

end
