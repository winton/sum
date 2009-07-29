Application.class_eval do
  helpers do
    
    def errors_on(attribute)
      @user && @user.errors.on(attribute)
    end
    
    def field(type, attribute, question)
      partial(
        :field,
        :locals => {
          :attribute => attribute,
          :checkbox => type == :checkbox,
          :question => question
        }
      )
    end
    
    def valid?(attribute=nil)
      if attribute
        @user && @user.errors.on(attribute).nil?
      else
        @user && @user.valid?
      end
    end
  end
end