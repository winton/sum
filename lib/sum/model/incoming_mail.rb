class IncomingMail < ActionMailer::Base
  
  class <<self
    def process!
      if $mail.config
        Fetcher.create($mail.config[:imap]).fetch
      end
    end
  end
  
  def receive(mail)
    emails = parse_emails(mail.subject)
    numbers = parse_numbers(mail.subject, mail.body)
    start = parse_start(mail.subject, mail.body)
    stop = parse_stop(mail.subject, mail.body)
    
    if mail.from[0] && email = UserEmail.find_by_email(mail.from[0])
      user = email.user
    else
      return
    end
    
    if user
      emails.each do |email|
        user.add_email!(email, true)
      end
      numbers.each do |number|
        user.spend!(number)
      end
      email.activate! if start
      email.deactivate! if stop
    end
    
    [ emails, numbers, start, stop ]
  end
  
  def parse_emails(*args)
    args.collect { |text| text.scan(/\S+@\S+\.\S+/) }.flatten
  end
  
  def parse_numbers(*args)
    args.collect { |text|
      first_non_number = text.index(/[^-+\d\.\s]/)
      return [] if first_non_number == 0
      if first_non_number
        text = text[0..(first_non_number - 1)]
      end
      numbers = text.scan(/([-+]*)(\d+\.*\d*)/)
      numbers.collect do |number|
        operator, number = number
        (operator == '+' ? -1 : 1) * number.to_f
      end
    }.flatten
  end
  
  def parse_start(*args)
    args.collect { |text| text.strip[0..4].downcase == 'start' }.include?(true)
  end
  
  def parse_stop(*args)
    args.collect { |text| text.strip[0..3].downcase == 'stop' }.include?(true)
  end
end
