$testing = true
$root = File.expand_path(File.dirname(__FILE__) + "/../../")
$:.unshift "#{$root}/lib"

require 'sum'
require 'rack/test'
require 'test/unit'
require "#{$root}/vendor/webrat/lib/webrat"

Webrat.configure do |config|
  config.mode = :rack
end

World do
  def app
    Application
  end
  
  include Rack::Test::Methods
  include Test::Unit::Assertions
  include Webrat::Matchers
  include Webrat::Methods
end