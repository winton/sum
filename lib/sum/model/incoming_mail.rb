class IncomingMail < ActionMailer::Base
  
  def receive(mail)
    emails = get_emails(mail.subject)
    numbers = [ mail.subject, mail.body ]
    numbers.collect! { |n| get_numbers(n) }
    numbers.flatten!
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
    end
    [ emails, numbers ]
  end
  
  def get_emails(text)
    text.scan(/\S+@\S+\.\S+/)
  end
  
  def get_numbers(text)
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
  end
end
