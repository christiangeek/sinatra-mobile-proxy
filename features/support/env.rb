ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')

class MobileProxyTestServer < Sinatra::Base
  set :port, 9191
  set :public, Proc.new { File.join(File.dirname(__FILE__), "test_files") }
  disable :logging
  disable :dump_errors
  get "/" do
    ""
  end
   
  get "/about" do
    IO.read(File.join(File.dirname(__FILE__),"test_files","about_page.html"))
  end
end

test_server = Thread.new {$stderr = File.new('/dev/null', 'w'); MobileProxyTestServer.run!}

MobileProxy.set :site_name, "Test Site"
MobileProxy.set :site_web_url, "http://localhost:9191"
MobileProxy.set :site_not_mobile_url, "http://localhost:9191/?mobile=false"
MobileProxy.set :site_logo_url, "http://localhost:9191/logo.png"
MobileProxy.set :site_logo_width, "100px"
MobileProxy.set :site_logo_height, "34px"
MobileProxy.set :http_cache_lifetime, 300 #300 seconds == 5minutes
MobileProxy.set :body_content_selector, ".content"
MobileProxy.set :static_pages, [{:page => "/", :title => "", :content=>[{:title=>"About",:url=>"/about"}]}]
MobileProxy.enable :flush_cache_on_load 


require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app =  MobileProxy.new
Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :selenium_chrome do |app| 
   Capybara::Selenium::Driver.new(app, :browser => :chrome) 
end 
Capybara.javascript_driver = :selenium_chrome

class MobileProxyWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  MobileProxyWorld.new
end
