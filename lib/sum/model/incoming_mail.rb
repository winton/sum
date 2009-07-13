class IncomingMail < ActionMailer::Base
  
  def receive(mail)
    numbers = [ mail.subject, mail.body ]
    numbers.collect! { |n| get_numbers(n) }
    numbers.flatten!
    return nil if numbers.empty?
    if mail.from[0] && user = User.find_by_email(mail.from[0])
      numbers.each do |number|
        user.spend!(number)
      end
      numbers
    else
      nil
    end
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
