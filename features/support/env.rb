$testing = true
$root = File.expand_path(File.dirname(__FILE__) + "/../../")
$:.unshift "#{$root}/lib"

require 'sum'

gem 'bmabey-email_spec', '=0.2.0'
gem 'rspec', '=1.2.7'

require 'email_spec'
require 'rack/test'
require 'spec/mocks'
require 'test/unit'
require "#{$root}/vendor/webrat/lib/webrat"

World do
  def app
    Application
  end
  
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rack::Test::Methods
  include Test::Unit::Assertions
  include Webrat::Matchers
  include Webrat::Methods
end