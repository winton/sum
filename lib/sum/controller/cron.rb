Application.class_eval do
  
  get '/cron' do
    path = "#{self.class.root}/config/mail.yml"
    if File.exists?(path)
      config = YAML::load(File.open(path))
      config = config[self.class.environment.to_s]['imap'].to_options
      default = {
        :type => :imap,
        :receiver => IncomingMail
      }
      Fetcher.create(default.merge(config)).fetch
    end
    ''
  end
end
