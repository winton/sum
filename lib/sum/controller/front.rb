Application.class_eval do
  
  get '/' do
    haml :front
  end
  
  post '/new' do
    @title = 'New budget'
    @user = User.find_by_email(params[:user][:email])
    if @user
      @user.update_attributes(params[:user])
    else
      @user = User.create(params[:user])
    end
    haml :new
  end
end
