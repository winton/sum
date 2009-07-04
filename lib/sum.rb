begin
  require 'rubygems'
  gem 'haml', '=2.0.9'
  gem 'sinatra', '=0.9.2'
  gem 'winton-active_wrapper', '=0.1.4'
  gem 'winton-fetcher', '=0.1.2'

rescue Exception
  Dir["#{File.dirname(__FILE__)}/../vendor/*/lib"].each do |path|
    $:.unshift path
  end
end

require 'haml'
require 'sinatra/base'
require 'active_wrapper'
require 'fetcher'

class Application < Sinatra::Base
end

Dir["#{File.dirname(__FILE__)}/sum/**/*.rb"].each do |path|
  require path
end