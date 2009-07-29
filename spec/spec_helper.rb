$testing=true
SPEC = File.dirname(__FILE__)
$:.unshift File.expand_path("#{SPEC}/../lib")

require 'sum'
require 'pp'

Spec::Runner.configure do |config|
end

def create_valid_user
  User.create(
    :email => "cucumber@sumapp.com",
    :bills => "1000.02",
    :income => "2500.54",
    :savings => "500.02",
    :timezone_offset => "-25200",
    :tos => '1'
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
Return-Path: <#{options[:from] || 'cucumber@sumapp.com'}>
From: Winton Welsh <#{options[:from] || 'cucumber@sumapp.com'}>
To: test@sumapp.com
Subject: #{options[:subject] || ''}
Content-Type: multipart/alternative; boundary=000325574d2a5057e1046eae4ba5

--000325574d2a5057e1046eae4ba5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#{options[:body] || ''}

--000325574d2a5057e1046eae4ba5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#{options[:body] || ''}<br>

--000325574d2a5057e1046eae4ba5--
EMAIL
end

def migrate_reset
  orig_stdout = $stdout
  $stdout = File.new('/dev/null', 'w')
  $db.migrate_reset
  $stdout = orig_stdout
end
