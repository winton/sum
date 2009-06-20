Application.class_eval do
  
  enable :raise_errors
  
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
  require 'active_support/core_ext/numeric/time'
  
  # Helpers
  helpers do
    def errors_on(attribute)
      @user && @user.errors.on(attribute)
    end
    
    def field(attribute, question)
      partial(
        :field,
        :locals => {
          :attribute => attribute,
          :question => question
        }
      )
    end
    
    def partial(name, options={})
      haml name, options.merge(:layout => false)
    end
    
    def valid?(attribute=nil)
      if attribute
        !@user || @user.errors.on(attribute)
      else
        @user && @user.valid?
      end
    end
  end
end
