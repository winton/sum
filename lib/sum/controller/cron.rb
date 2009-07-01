Application.class_eval do
  
  get '/cron' do
    # Process incoming emails
    Fetcher.create($mail.config[:imap]).fetch
    # Reset users
    conditions = [ 'reset_at <= ?', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.reset!
    end
    # Send emails
    conditions = [ 'send_now = 1 OR (failures <= 5 AND send_at <= ?)', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.reset_spent_today
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
    end
    true
  end
end