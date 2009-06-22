Dir["#{File.dirname(__FILE__)}/../vendor/*/lib"].each do |path|
  $:.unshift path
end

require 'active_wrapper'
require 'fetcher'
require 'sinatra/base'

class Application < Sinatra::Base
end

Dir["#{File.dirname(__FILE__)}/sum/**/*.rb"].each do |path|
  require path
end