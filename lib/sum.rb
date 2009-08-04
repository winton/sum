require 'rubygems'

gems = [
  [ 'haml', '=2.2.2' ],
  [ 'sinatra', '=0.9.4' ],
  [ 'winton-active_wrapper', '=0.1.9' ],
  [ 'winton-fetcher', '=0.1.2' ],
  [ 'winton-secret_key', '=0.1.0' ]
]

gems.each do |name, version|
  begin
    gem name, version
  rescue Exception
    $:.unshift "#{File.dirname(__FILE__)}/../vendor/#{name}/lib"
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