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
Return-Path: <#{options[:from] || 'cucumber@sumapp.com'}>
From: Winton Welsh <#{options[:from] || 'cucumber@sumapp.com'}>
To: test@sumapp.com
Subject: #{options[:subject] || ''}

#{options[:body] || ''}

EMAIL
end