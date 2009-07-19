Application.class_eval do
  
  get "/#{@secret_key}" do
    IncomingMail.process!
    User.reset_users!
    User.reset_spent_today!
    User.send_emails! do |user|
      haml(:email, :layout => false, :locals => { :u => user })
    end
    true
  end
end