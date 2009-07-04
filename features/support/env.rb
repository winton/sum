$testing = true
$root = File.expand_path(File.dirname(__FILE__) + "/../../")
$:.unshift "#{$root}/lib"

require 'sum'
require 'email_spec'
require 'rack/test'
require 'spec/mocks'
require 'test/unit'
require "#{$root}/vendor/webrat/lib/webrat"

Webrat.configure do |config|
  config.mode = :rack
end

Before do
  $rspec_mocks ||= Spec::Mocks::Space.new
end

After do
  begin
    $rspec_mocks.verify_all
  ensure
    $rspec_mocks.reset_all
  end
end

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