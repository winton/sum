$TESTING=true
SPEC = File.dirname(__FILE__)
$:.unshift File.expand_path("#{SPEC}/../lib")

require 'sum'
require 'pp'
require 'spec/interop/test'
require 'rack/test'

Spec::Runner.configure do |config|
end

def create_valid_user
  User.create(
    :email => "test@test.com",
    :bills => "1000.02",
    :income => "2500.54",
    :savings => "500.02",
    :timezone_offset => "-25200"
  )
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end

def generate_email(options={})
<<EMAIL
Delivered-To: test@sumapp.com
Return-Path: <#{options[:from] || 'test@test.com'}>
From: Winton Welsh <#{options[:from] || 'test@test.com'}>
To: test@sumapp.com
Subject: #{options[:subject] || ''}

#{options[:body] || ''}

EMAIL
end

def migrate_reset
  orig_stdout = $stdout
  $stdout = File.new('/dev/null', 'w')
  $db.migrate_reset
  $stdout = orig_stdout
end
