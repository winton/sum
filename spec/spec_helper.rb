$TESTING=true
SPEC = File.dirname(__FILE__)
$:.unshift File.expand_path("#{SPEC}/../lib")

require 'sum'
require 'pp'
require 'spec/interop/test'
require 'rack/test'

Spec::Runner.configure do |config|
  $db.migrate_reset
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end
