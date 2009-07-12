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
  User.find_by_email(current_email_address)
end