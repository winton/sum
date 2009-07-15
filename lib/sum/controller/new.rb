Application.class_eval do
  
  post '/new' do
    if email = UserEmail.find_by_email(params[:user][:email])
      if @user = email.user
        @user.send_now = true
        @user.update_attributes(params[:user])
      end
    else
      @user = User.create(params[:user])
    end
    @title = valid? ? 'Success!' : 'Fix mistakes'
    haml :new
  end
end
