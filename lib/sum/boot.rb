Application.class_eval do
  
  set :root, File.expand_path("#{File.dirname(__FILE__)}/../../")
  set :public, "#{root}/public"
  set :logging, true
  set :static, true
  set :views, "#{root}/lib/sum/view"
    
  # Set up database and logging
  $db, $log = ActiveWrapper.setup(
    :base => root,
    :env => environment,
    :stdout => true
  )
  $db.establish_connection
  
  # Require controllers and models
  Dir["#{root}/lib/sum/**/*.rb"].each do |path|
    require path unless path == __FILE__
  end
  
  # Gems
  require 'rubygems'
  require 'haml'
end
