Application.class_eval do
  
  get '/' do
    haml :front
  end
  
  post '/new' do
    @user = User.create(params[:user])
    haml :new
  end
end
