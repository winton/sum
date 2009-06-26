Application.class_eval do
  
  get '/fetch' do
    Fetcher.create($mail.config[:imap]).fetch
    true
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
      body = erb(:email, :locals => { :u => user })
      begin
        $mail.deliver(
          :from => 'sum@sumapp.com',
          :to => user.email,
          :subject => "Today's budget",
          :body => body
        )
        user.sent!
      rescue Exception
        user.increment!(:failures)
      end
      true
    end
  end
end