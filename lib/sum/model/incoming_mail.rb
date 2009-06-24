class IncomingMail < ActionMailer::Base
  
  def receive(mail)
    body = [ mail.subject, mail.body ].join(' ')
    numbers = body.scan(/([-+]*)(\d+\.*\d*)/)
    return if numbers.empty?
    numbers.collect! do |number|
      operator, number = number
      (operator == '+' ? 1 : -1) * number.to_f
    end
    if mail.from[0] && user = User.find_by_email(mail.from[0])
      user.recent_transactions ||= []
      numbers.each do |number|
        user.recent_transactions.unshift(number)
        user.spent_this_month += number
      end
      user.save
      numbers
    else
      nil
    end
  end
end
