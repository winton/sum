$testing = true
$root = File.expand_path(File.dirname(__FILE__) + "/../../")
$:.unshift "#{$root}/lib"

require 'sum'

gems = [
  [ 'email_spec', '=0.3.5' ],
  [ 'rack-test', '=0.5.3' ],
  [ 'rspec', '=1.2.9' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'email_spec'
require 'email_spec/cucumber'
require 'rack/test'
require 'spec/mocks'
require 'test/unit'
require 'webrat'

World do
  def app
    Application
  end

  include Rack::Test::Methods
  include Test::Unit::Assertions
  include Webrat::Matchers
  include Webrat::Methods
end