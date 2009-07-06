class IncomingMail < ActionMailer::Base
  
  def receive(mail)
    body = [ mail.subject, mail.body ].join(' ')
    numbers = body.scan(/([-+]*)(\d+\.*\d*)/)
    return if numbers.empty?
    numbers.collect! do |number|
      operator, number = number
      (operator == '+' ? -1 : 1) * number.to_f
    end
    # Only record the first number if the email
    # contains non-number characters (reply)
    if body =~ /[^-+\d\.\s]/
      numbers = numbers[0..0]
    end
    if mail.from[0] && user = User.find_by_email(mail.from[0])
      numbers.each do |number|
        user.spend!(number)
      end
      numbers
    else
      nil
    end
  end
end
