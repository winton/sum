Application.class_eval do
  
  get '/' do
    haml :front
  end
  
  post '/new' do
    @title = 'New budget - '
    @title += valid? ? 'Success!' : 'Fix mistakes'
    if @user = User.find_by_email(params[:user][:email])
      @user.update_attributes(params[:user])
    else
      @user = User.create(params[:user])
    end
    haml :new
  end
end
