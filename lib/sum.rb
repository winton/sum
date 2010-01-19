require 'rubygems'

gems = [
  [ 'active_wrapper', '=0.2.3' ],
  [ 'fetcher', '=0.1.2' ],
  [ 'haml', '=2.2.14' ],
  [ 'secret_key', '=0.1.0' ],
  [ 'sinatra', '=0.9.4' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'haml'
require 'sinatra/base'
require 'active_wrapper'
require 'fetcher'
require 'secret_key'

class Application < Sinatra::Base
end

Dir["#{File.dirname(__FILE__)}/sum/**/*.rb"].sort.each do |path|
  require path
end