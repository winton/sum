require 'rubygems'

begin
  gem 'winton-secret_key', '=0.1.0'
rescue Exception
  $:.unshift "#{File.dirname(__FILE__)}/vendor/winton-secret_key/lib"
end

require 'secret_key'
key = SecretKey.new(File.dirname(__FILE__)).read

every 1.minute do
  case @environment
  when 'production'
    command "curl http://beta.sumapp.com/#{key}"
  when 'development'
    command "curl http://localhost:#{@port}/cron"
  end
end