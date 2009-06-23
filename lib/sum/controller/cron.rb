Application.class_eval do
  
  get '/receive_mail' do
    default = {
      :receiver => IncomingMail,
      :type => :imap
    }
    config = default.merge($mail.config[:imap])
    Fetcher.create(config).fetch
  end
  
  get '/send_mail' do
  end
end