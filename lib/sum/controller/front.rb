Application.class_eval do
  get '/' do
    haml :front
  end
end
