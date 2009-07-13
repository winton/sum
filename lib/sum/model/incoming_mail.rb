class IncomingMail < ActionMailer::Base
  
  def receive(mail)
    emails = get_emails(mail.subject)
    numbers = get_numbers(mail.subject, mail.body)
    start = get_start(mail.subject, mail.body)
    stop = get_stop(mail.subject, mail.body)
    if mail.from[0] && email = UserEmail.find_by_email(mail.from[0])
      user = email.user
    else
      return
    end
    if user
      emails.each do |email|
        user.emails.create(:email => email)
      end
      numbers.each do |number|
        user.spend!(number)
      end
      email.update_attribute(:active, true) if start
      email.update_attribute(:active, false) if stop
    end
    [ emails, numbers, start, stop ]
  end
  
  def get_emails(*args)
    args.collect { |text| text.scan(/\S+@\S+\.\S+/) }.flatten
  end
  
  def get_numbers(*args)
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
  
  def get_start(*args)
    args.collect { |text| text.strip[0..4].downcase == 'start' }.include?(true)
  end
  
  def get_stop(*args)
    args.collect { |text| text.strip[0..3].downcase == 'stop' }.include?(true)
  end
end
