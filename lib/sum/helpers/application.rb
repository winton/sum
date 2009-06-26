Application.class_eval do
  helpers do
    
    def partial(name, options={})
      haml name, options.merge(:layout => false)
    end
  end
end