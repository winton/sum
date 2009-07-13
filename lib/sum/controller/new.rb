Application.class_eval do
  
  post '/new' do
    @title = valid? ? 'Success!' : 'Fix mistakes'
    @title = [ 'New budget', @title ].compact.join(' - ')
    if email = UserEmail.find_by_email(params[:user][:email])
      if @user = email.user
        @user.send_now = true
        @user.update_attributes(params[:user])
      end
    else
      @user = User.create(params[:user])
    end
    haml :new
  end
end
