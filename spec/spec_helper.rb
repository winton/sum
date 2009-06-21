$TESTING=true
SPEC = File.dirname(__FILE__)
$:.unshift File.expand_path("#{SPEC}/../lib")

require 'sum'
require 'pp'

Spec::Runner.configure do |config|
  $db, $log = ActiveWrapper.setup(
    :base => File.expand_path("#{SPEC}/../"),
    :env => 'test'
  )
  $db.establish_connection
  $db.migrate_reset
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end
