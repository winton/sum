require "#{File.dirname(__FILE__)}/model/incoming_mail"

Application.class_eval do
  
  # Sinatra
  enable :raise_errors
  set :environment, $testing ? :test : environment
  set :root, File.expand_path("#{File.dirname(__FILE__)}/../../")
  set :public, "#{root}/public"
  set :logging, true
  set :static, true
  set :views, "#{root}/lib/sum/view"
    
  # Database, logging, and email
  $db, $log, $mail = ActiveWrapper.setup(
    :base => root,
    :env => environment,
    :stdout => environment != :test
  )
  $db.establish_connection
  if $mail.config
    imap = { :receiver => IncomingMail, :type => :imap }
    $mail.config[:imap].merge!(imap)
  end
end
