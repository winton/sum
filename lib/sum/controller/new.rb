Application.class_eval do
  
  post '/new' do
    @title = valid? ? 'Success!' : 'Fix mistakes'
    @title = [ 'New budget', @title ].compact.join(' - ')
    if @user = User.find_by_email(params[:user][:email])
      @user.update_attributes(params[:user])
    else
      @user = User.create(params[:user])
    end
    haml :new
  end
end
