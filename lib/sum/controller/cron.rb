Application.class_eval do
  
  get '/cron' do
    # Process incoming emails
    if $mail.config
      Fetcher.create($mail.config[:imap]).fetch
    end
    # Reset users
    conditions = [ 'reset_at <= ?', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.reset!
    end
    # Reset spent today
    conditions = [ 'send_at <= ?', Time.now.utc ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      user.reset_spent_today!
    end
    # Send emails
    conditions = [
      'send_now = 1 OR send_at <= ?',
      Time.now.utc
    ]
    users = User.find(:all, :conditions => conditions)
    users.each do |user|
      body = haml(
        :email,
        :layout => false,
        :locals => { :u => user }
      )
      begin
        user.emails.each do |email|
          @email = email
          next unless email.active? && email.failures <= 5
          $mail.deliver(
            :from => 'sum@sumapp.com',
            :to => email.email,
            :subject => "Today's budget",
            :body => body
          )
          email.sent!
        end
        user.sent!
      rescue Exception => e
        # In test mode, this is actually catching an error caused by a weird issue with email_spec
        # resetting the rack session when an email delivers (I think).
        unless self.class.environment == :test
          @email.increment!(:failures)
        end
      end
    end
    true
  end
end