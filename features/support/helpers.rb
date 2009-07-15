def current_email_address
  "cucumber@sumapp.com"
end

def fill_all_with_valid_data(hash={})
  valid = {
    'savings' => '0',
    'income' => '0',
    'bills' => '0',
    'email' => current_email_address
  }.merge(hash)
  valid.each do |key, value|
    fill_in "user[#{key}]", :with => value
  end
end

def find_user
  UserEmail.find_by_email(current_email_address).user
end

def generate_email(options={})
<<EMAIL
Delivered-To: test@sumapp.com
Return-Path: <#{options[:from] || current_email_address}>
From: Winton Welsh <#{options[:from] || current_email_address}>
To: test@sumapp.com
Subject: #{options[:subject] || ''}
Content-Type: multipart/alternative; boundary=000325574d2a5057e1046eae4ba5

--000325574d2a5057e1046eae4ba5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#{options[:body] || ''}

--000325574d2a5057e1046eae4ba5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#{options[:body] || ''}<br>

--000325574d2a5057e1046eae4ba5--
EMAIL
end
