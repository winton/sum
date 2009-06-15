Dir["#{File.dirname(__FILE__)}/../vendor/*/lib"].each do |path|
  $:.unshift path
end

require 'active_wrapper'
require 'sinatra/base'

class Application < Sinatra::Base
end

require "#{File.dirname(__FILE__)}/sum/boot"
