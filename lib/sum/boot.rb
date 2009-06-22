Application.class_eval do
  
  enable :raise_errors
  
  set :environment, $TESTING ? :test : environment
  set :root, File.expand_path("#{File.dirname(__FILE__)}/../../")
  set :public, "#{root}/public"
  set :logging, true
  set :static, true
  set :views, "#{root}/lib/sum/view"
    
  # Set up database and logging
  $db, $log, $mail = ActiveWrapper.setup(
    :base => root,
    :env => environment,
    :stdout => environment != :test
  )
  $db.establish_connection
  
  # Gems
  require 'rubygems'
  require 'haml'
  
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
