class IncomingMail < ActionMailer::Base
  
  class <<self
    def process!
      unless $testing
        Fetcher.create($mail.config[:imap]).fetch
      end
    end
  end
  
  def receive(mail)
    return unless body = get_body(mail)
    emails = parse_emails(mail.subject, body.body)
    numbers = parse_numbers(mail.subject, body.body)
    start = parse_start(mail.subject, body.body)
    stop = parse_stop(mail.subject, body.body)
    
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
  
  private
  
  def get_body(mail)
    if mail.parts.empty?
      mail
    else
      mail.parts.select { |part|
        part['content-type'].content_type == 'text/plain'
      }.first
    end
  end
  
  def parse_emails(*args)
    args.collect { |text|
      text = text_upto(text, /\s/)
      text.scan(/\S+@\S+\.\S+/)
    }.flatten
  end
  
  def parse_numbers(*args)
    args.collect { |text|
      text = text_upto(text, /[^-+\d\.\s]/)
      numbers = text.scan(/([-+]*)(\d+\.*\d*)/)
      numbers.collect do |number|
        operator, number = number
        (operator == '+' ? -1 : 1) * number.to_f
      end
    }.flatten
  end
  
  def parse_start(*args)
    args.collect { |text|
      text.strip[0..4].downcase == 'start'
    }.include?(true)
  end
  
  def parse_stop(*args)
    args.collect { |text|
      text.strip[0..3].downcase == 'stop'
    }.include?(true)
  end
  
  def text_upto(text, regex)
    first_instance = text.index(regex)
    return '' if first_instance == 0
    if first_instance
      text[0..first_instance-1]
    else
      text
    end
  end
end
