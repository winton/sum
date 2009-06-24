Application.class_eval do
  
  get '/fetch' do
    Fetcher.create($mail.config[:imap]).fetch
  end
  
  get '/reset_and_send' do
    # Reset users
    conditions = [ 'reset_at <= ?', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.reset!
    end
    # Send emails
    conditions = [ 'failures <= 5 AND send_at <= ?', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.deliver!
    end
  end
end